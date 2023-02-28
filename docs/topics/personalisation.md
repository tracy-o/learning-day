# Personalisation

Personalisation means user-tailored content, i.e. displaying different content
for different users be it authenticated vs non-authenticated or different
content for authenticated users depending on their profile.

## Role of Belfrage in personalisation

The role of Belfrage when it comes to personalisation is the same as in other
areas: to enable efficiency and resilience for upstream layers.

Personalisation in general means more traffic for the upstream layers because
they need to generate user-tailored content instead of the same content for
everyone that can be cached downstream. This increases the risk and Belfrage
aims to mitigate that.

Personalisation mechanism is the same regardless of the origin that generates
the content, so Belfrage aims to take on some processing that would otherwise
need to happen in each origin.

In particular, Belfrage implements:

* A way to turn personalisation off globally via a dial (e.g. in case of an
  incident).
* A way for teams to indicate that a route supports personalisation.
* Validation of the current user's session (and prompts re-authentication if
  it's invalid).
* Indication that a request is personalised to upstream layers and current
  user's profile details.
* Non-personalised fallbacks when the origin responds with an error.

Here's a diagram illustrating what Belfrage does when it comes to
personalisation:

![Personalisation in Belfrage](../img/belfrage-personalisation.svg)

[Diagram source](../img/source/belfrage-personalisation.drawio)

## Personalisation dial

Personalisation can be turned off per stack using the 'Personalisation' dial.
When it's off Belfrage will treat all incoming requests as non-personalised and
won't provide user profile details to origins. It will serve non-personalised
early responses and fallbacks to users.

## Personalised routes

Please see this [Routing](routing/routing.md)
for info on how teams can enable personalisation for a route.

Note that only requests to `*.bbc.co.uk` can be personalised currently.

## User session validation

In Belfrage a user is considered authenticated if:

* The value of the request header `x-id-oidc-signedin` (set by GTM) is '1' or
* Identity token (`ckns_id` cookie) is present in the request

User's session is considered valid if a valid user access token (`ckns_atkn`
cookie) is present in the request.

If an authenticated user accesses a personalised route and their user access
token is not valid, they are redirected to the BBC Account URL
https://session.bbc.co.uk/session. Belfrage adds a `ptrt` query parameter to
the URL (the page to return to) which lets the Account signing page know where
to redirect the users after authentication.

### Validation process

You may be aware of the [BBC API
Management](https://github.com/bbc/api-management/wiki) tools that already
exist and wonder what we may be doing differently. Our solution is based
closely on a subset of that package and we work with the team there to enable
the required features in Belfrage.

Belfrage validates that the user's access token has the correct issuer and
audience values. It also verifies the name of the token, because only one token
type is currently supported.

The following claims are validated:

* tokenName = access_token
* exp is later than current time + configured expiry threshold (currently 70
  minutes), i.e. that the token hasn't expired and won't expire within the
  configured window.

The token is also verified as well as validated. To verify a token Belfrage
uses the BBC Account key to ensure that the token was signed by the BBC. For
performance reasons Belfrage keeps the available account keys in memory with a
GenServer process periodically running in the background to refresh the list.

Each user's token is signed using a specific key. The header of the users
access token specifies which key was used to sign it:

* kid
* alg

Belfrage uses both these values to ensure a unique key is returned from the list
(there may be multiple keys with the same `kid`).

### BBC Account Keys

The Account keys are provided by the BBC Account team (see
[C4](../architecture/architecture.md#level-2-container-diagrams)). Upon deployment of
Belfrage the keys are fetched and stored in memory. They are then periodically
fetched to ensure they remain up to date.

Should there be an issue fetching the keys, the existing set in memory will be
used until the next refresh period. Should there be an issue on deployment a
fallback set will be used. The fallback set is the list of keys fetched and
then hard baked during the creation of the release archive.

The keys returned are of the [JWK format](https://tools.ietf.org/html/rfc7517).

The endpoint to fetch the keys is
https://access.api.bbc.com/v1/oauth/connect/jwk_uri and this is currently
fetched every hour (check the GenServer module in case this changes).

The `JWK_URI` requires the relevant BBC Authentication so Belfrage makes the
request using the Client certificates provided by Cosmos.

### Handling key revocation

If the Account JWK keys are revoked there will be a period of time, until the
next fetch is performed, where Belfrage is unable to successfully verify newly
signed in users. A manual process exists where the keys can be updated manually
on each instance should this be required.

### BBC ID availability

Belfrage periodically checks the status of BBC ID services to determine if
personalisation should be enabled or not. If BBC ID services are unavailable or
degraded, personalisation is turned off.

The status of BBC ID services (aka [BBC ID
flagpole](https://confluence.dev.bbc.co.uk/pages/viewpage.action?pageId=135467558))
is retrieved from the [IDCTA config
endpoint](https://confluence.dev.bbc.co.uk/display/BBCAccount/FE+-+BBC+IDCTA+config).
The status can be either `GREEN` ('available') or `RED` ('unavailable').

The default assumption is that BBC ID services are available. Belfrage polls
the status every 10 seconds, and stores it in a process called
`Belfrage.Authentication.BBCID`. The status can be checked by calling
`Belfrage.Authentication.BBCID.available?/0` function.

## Personalised requests to upstream services

Belfrage considers a request personalised if:

* Personalisation is enabled (dial is on, BBC ID is available).
* Requested route is personalised in the current environment.
* User is authenticated.
* User's session is valid.

For personalised requests, Belfrage sets the following headers when making a
request to an origin:

```
authorization: Bearer [ckns_atkn]
x-authentication-provider: idv5
pers-env: [live or test]
ctx-pii-age-bracket: [user's age bracket]
ctx-pii-allow-personalisation: [has the user allowed personalisation]
```

Belfrage only supports v5 of the BBC Account.

## Caching and fallbacks

Belfrage doesn't serve cached early responses to personalised requests: it
always makes a request to the origin.

Belfrage doesn't store personalised responses in the cache. It also verifies
the `cache-contol` header that origins return in response to personalised
requests. If an origin responds with `cache-control: public`, Belfrage updates
that to `private`.

If Belfrage receives an error from an origin in response to a personalised
request, it will attempt to serve a non-personalised fallback. It will mark
such fallback as private (as well as the error response if there's no
fallback).

Responses from Belfrage contain `Vary` header, the value of which includes
`x-id-oidc-signedin` for requests to personalised routes. I.e. GTM is expected
to vary the response on the authenticated status of the user: non-authenticated
users can only be served a non-personalised cached response. Authenticated
users are not served a cached response at all because all personalised
responses are private.

GTM marks the responses that it varies on `x-id-oidc-signedin` as private: i.e.
downstream layers won't cache it. To avoid this when personalisation is turned
off (e.g. in case of an incident, when we want to reduce the load on GTM and
upstream), Belfrage doesn't include `x-id-oidc-signedin` in the `Vary` header.
When personalisation is off all users (both authenticated and not) get the same
responses, so they are always public and can be cached downstream.

---

# Personalisation Journey through Belfrage
```
| stage                | personalisation process                                                                                                    | request type | module                   |
|----------------------+----------------------------------------------------------------------------------------------------------------------------+-------------+--------------------------|
| pre_request_pipeline | check authorisation header exists                                                                                          | App         | Belfrage.SessionState    |
| pre_request_pipeline | check ckns_id cookie exists or x-id-oidc-signedin header == "1"                                                            | Web         | Belfrage.SessionState    |
| pre_request_pipeline | check BBC ID Availability is "GREEN" and Personalisation dial is on                                                        | App,Web     | Belfrage.SessionState    |
| pre_request_pipeline | update envelope.request.personalised_request to true                                                                       | App,Web     | Belfrage.Personalisation |
| pre_request_pipeline | append header allowlist with x-id-oidc-signedin                                                                            | Web         | Belfrage.Personalisation |
| pre_request_pipeline | append cookie allowlist ckns_atkn,ckns_id                                                                                  | Web         | Belfrage.Personalisation |
| pre_request_pipeline | append header allowlist with authorization,x-authentication-provider                                                       | App         | Belfrage.Personalisation |
| pre_request_pipeline | do not fetch early reponse from cache if envelope.request.personalised_request is true                                     | App,Web     | AppPersonalisationHalter |
| request_pipeline     | return 204 response if personalisation is not enabled                                                                      | App         | AppPersonalisationHalter |
| request_pipeline     | return 401 response if authorization header exists but token is invalid or expired                                         | App         | Personalisation          |
| request_pipeline     | return 302 redirect if ckns_id cookie exists or x-id-oidc-signedin header == "1" but ckns_atkn token is invalid or expired | Web         | Personalisation          |
| perform_call         | add authorization,x-authentication-provider to vary header                                                                 | App         | Belfrage.Response        |
| perform_call         | add x-id-oidc-signed in to vary header                                                                                     | Web         | Belfrage.Response        |
| response_pipeline    | do not store in cache if cache-control is private                                                                          | App,Web     | Belfrage.Cache.Store     |
| response_pipeline    | mark the cache-control as private if envelope.private.personalised_request is true                                         | App,Web     | Processor                |
```

## pre_request_pipeline

### Marking the request as personalised

When a request (`%Conn{}`) is matched against a route in `Routes.Routefiles.Main.Live`, it is passed to `BelfrageWeb.yield`, which adapts the `%Conn{}` to an `%Envelope{}`.

`BelfrageWeb.yield` then passes the `%Envelope{}` to `Belfrage.handle`, which in turn passes it through a pipeline called `pre_request_pipeline` (found in `Belfrage.Processor`).

`pre_request_pipeline` does some transformations on the `%Envelope{}` via a set of functions - the relevant functions for us are `get_route_state/1` and `maybe_put_personalised_request/1`, found in `Belfrage.Processor` and `Belfrage.Personalisation` respectively.

`get_route_state/1` is important as it updates the `%Envelope{}` with data that lets Belfrage know if the route that it has matched on is personalised or not i.e. `envelope.private.personalised_route`.

`maybe_put_personalised_request/1` uses `envelope.private.personalised_route` as well as a number of request headers and/or cookies and dial values to determine if the request should be marked as personalised,  i.e. `envelope.private.personalised_request`.

We discuss these checks below.

`maybe_put_personalised_request/1` uses the `personalised_request?` function, found in `Belfrage.Personalisation` which runs a series of checks to determine whether or not a request is personalised.

If following checks pass then we mark the request as personalised by setting `envelope.private.personalised_request` to `true`.

**Request attributes that are checked**

The first request attribute that is checked is `envelope.request.host` - this must end with `bbc.co.uk`.

The other request attributes that are checked depend on the nature of the request.

If the request is an app request i.e. `envelope.request.app?` is `true`, then the following must be true:
* The `authorization` exists.

If the request is not an app request i.e. `envelope.request.app?` is `false`, then one of the following must be true:
* The `ckns_id` cookie exists
* The `x-id-oidc-signedin` request header equals `"1"`

**Other values that are checked**

We also check that personalisation is enabled by checking if:

* The BBC ID service status is available, or `GREEN`.
* The `:personalisation** dial in Belfrage has a truthy value.

### Appending Allowlists

Another Personalisation concern is the appending of the allowlists using the `append_allowlists` function in the `Belfrage.Personalisation` module.

Without this operation the neccessary request headers/cookies would be filtered out.

If the request is an app request, then we add the following to the `headers_allowlist`:
* `"authorization"`
* `"x-authentication-provider"`

If the request is a web request, then we add the following to the `headers_allowlist`:
* `"x-id-oidc-signedin"`

and the following to the `cookie_allowlist`:
* `"ckns_atkn"`
* `"ckns_id"`

## fetch_early_response_from_cache

The next personalisation concern is determining whether or not an early response is cached, using the `fetch_early_response_from_cache` function found in the `Belfrage.Processor` module.

If `envelope.private.personalised_request` is `true` then we do not fetch an early response from the cache.

## request_pipeline

The next stage that occurs is the request pipeline, which runs a series of Request Transformers on the `%Envelope{}`.

The transformers that are used depend on the `request_pipeline` specified by the `RouteSpec`, but the important transformers here are `AppPersonalisationHalter` and `Personalisation`.

### AppPersonalisationHalter

This Request Transformer checks if `envelope.request.app?` is `true` - if it is then we check that personalisation is enabled by checking if:

* The BBC ID service status is available, or `GREEN`.
* The `:personalisation` dial in Belfrage has a truthy value.

If the request is an app request and personalisation is not enabled, then a `204` response is returned.

### Personalisation

This Request Transformer checks the following request values:

If the request is an app request i.e. `envelope.request.app?` is `true`, then the following must be true:
* The `authorization` header exists.

If the request is not an app request i.e. `envelope.request.app?` is `false`, then one of the following must be true:
* The `ckns_id` cookie exists
* The `x-id-oidc-signedin` request header equals `"1"`

Validation also occurs on the user token, which is found in the `authorization` header for app requests and the `ckns_atkn` header for non-app requests.

We check that the `tokenName` attribute is equal to `access_token` and that the token has not expired  using the `exp` attribute.

If the request is an app request, the `authorization` header exists and the token is not valid or has expired then a 401 response is returned.

If the request is a web request, the `ckns_id` cookie exists, and the token is not valid or has expired then a 302 redirect is returned.

If the request is a web request, the `x-id-oidc-signedin` request header equals `"1"` and the token is not valid or has expired then a 302 redirect is returned.

## perform_call

The next personalisation concern is the `"vary"` header in the response.

The vary header is constructed from the allowlists, which were appended to in the `Appending Allowlists` stage.

The `x-id-oidc-signedin` header will be removed from the vary header if:

* The route is personalised
* `envelope.request.host` ends with `bbc.co.uk`
* The BBC ID service status is available, or `GREEN`.
* The `:personalisation` dial in Belfrage has a truthy value.


## response_pipeline

If the `cache-control` has been marked as `"private"` then it will not be stored in the local or distributed cache.

As part of the response pipeline we may fetch a fallback for a subset of error status codes.

If the request has been marked as personalised, i.e. `envelope.private.personalised_request` is `true`, then we mark the `cache-control` to `"private"`.
