# Caching

## Caching tiers

Belfrage will provide two cascading caching layers:
### Tier 1 - Local Cache
A per-node in-memory LRU cache with no network involved and almost no latency. Currently, every Belfrage node can cache around 12Gb of content. 

We use a library `Cachex` for our local cache, see more [lib/belfrage/cache/local.ex](../../lib/belfrage/cache/local.ex)

NOTE: future iterations could implement smarter ways to determine which content has more chances to get a hit or requires continuous presence in the in-memory cache.


### Tier 2 - Distributed cache
A slower and longer-term cache on Amazon S3. 

We have a seperate application [Belfrage-ccp](https://github.com/bbc/belfrage-ccp) which is our central cache processor and deals with storing pages on S3. (Fetching pages is done by requesting straight from S3 within Belfrage)


## Design

Belfrage offers an optional caching and resiliency layer. Routes requiring these features can rely on faster response times, less load on the origin and the peace of mind of a fallback content in case of temporary faults. A route can disable caching by using the key `caching_enabled: false` in its routespec.

Personalised pages will not be able to use the cache feature. The fallback option will still be available. When a personalised route is requested the cache directive is set to private so it is not stored in cache however when a personalised request fails, we can return a non-personalised version in the form of a fallback.

On a request the first action Belfrage takes is to look for cached content in the local cache. The cached content will be returned if found and it is `fresh`. If not, a request to the origin is then made.

If the final response has a status code greater or equal to 400 that is not 404, 410 or 451 then the fallback mechanism kicks in.

Items in the cache are stored against a request hash which depends on a set of signature keys defined here: [lib/belfrage/request_hash.ex](../../lib/belfrage/request_hash.ex), this means two structs must have the same signature keys for them to match. These keys can be added to and skipped from the `signature_keys` key in the private of the struct.

## Fallback Mechanism

If Belfrage is unable to find fresh cached content from any of the service providers in the cascade it will then make requests to each of the service providers until it receives a response that is not a 404, if all responses are 404, it will return 404. 

Belfrage will then try to store this response in cache depending on a few factors such as if caching is enabled for that struct. Finally, if the response we have has a status code >=400 and is not 404, 401 or 451 and caching is enabled, we look for both fresh and stale content in the cache and if this reponse is a 200, we try to store it back in the cache.

Fallback TTL is currently configured as 6h.

[Where we store items in cache](../../lib/belfrage/cache/store.ex#6)
[Where we fetch fallbacks](../../lib/belfrage/processor.ex#103)

![Fallback Mechanism](../img/belfrage_fallback_mechanism.png)

# Caching & Circuit Breaker

The [Circuit Breaker](../../lib/belfrage/transformers/circuit_breaker.ex) is a transformer that is dependant on a dial. If the dial is set to true, the circuit breaker will be used otherwise it will not. 

The Circuit Breaker relies massively on the caching layer, Essentially the circuit breaker monitors routes error responses, and if a threshold is reached, it simulates an origin error to stop attempting to fetch content from the origin temporarily. In the meantime, the simulated failure triggers the fallback mechanism.

Error thresholds are configurable per-route from within the routespec, an example shown here: [lib/routes/specs/news_article_page.ex](../../lib/routes/specs/news_article_page.ex).


Currently the threshold must exceed the preovided number of errors in a specific amount of time, this is currently set to a value of 60s under the value of `long_counter_reset_interval` in [config/config.exs](../../config/config.exs). This means the number of errors is set to 0 every 60 seconds and if the circuit breaker activates it will only be active for the remainder of that 60 seconds until the error count is set back to 0.


## Metrics

Belfrage records metrics for each type of cache result. You will be able to see these on the Grafana Dashboards.

These are the metrics we record and when we record them:
- Local fresh hit: When an item is found in local cache and the time elapsed since stored is less than the max-age
- Local stale hit: When an item is found in local cache and the time elapsed since stored is greater than the max-age
- Local cache miss: When an item is not found in local cache
- Distributed fresh hit: ?
- Distributed stale hit: When a item is found in the distributed cache
- Distributed cache miss: When an item is not found in the distributed cache (S3)

## Cache flow

### Fetching fresh content

The following diagram shows the flow in Belfrage when requesting fresh cache content.

![belfrage-cache](../img/belfrage-cache-fresh.svg)

[Diagram source](../img/source/belfrage-cache-fresh.drawio)

### Caching in depth

The following diagram shows the detailed flow of cache content for fresh and stale content.

1. Check for "fresh" content in the local cache.
2. Check for "fresh" or "stale" content in the local or distributed cache (applicable when an origin has returned a 500 response).

![belfrage-cache](../img/belfrage-cache.svg)

[Diagram source](../img/source/belfrage-cache.drawio)
