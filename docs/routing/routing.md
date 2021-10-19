### Rationale

We want tenant users to be able to quickly add a new route to Belfrage with minimal effort.

A tenant should just:
- Define the route matcher in the `Routefile`
- Define one or more examples of routes in the `Routefile`
- Add basic information about their route in a `Spec File`

A tenant will not:
- Need to know Elixir
- Build unit tests in Elixir (but if they desire to do so they're welcome to!)

### Features
- Simple Domain Specific Language (DSL)
- Super performant independently of the number of route matchers
- Allow basic validation of routes
- Allow redirects
- More to come...

### Design 
The `Routefile` introduces a simple DSL to easily define routing rules. Just a few macros are used behind the scenes to perform a simple definition of the route. Once compiled, this becomes a single standard `Plug.Router` module.

The route specs are simple specifications of single routes, the properties are not at the moment validated but we plan to add it in a separate iteration, once the spec structure stabilises.

These two actors live in a separate directory `/lib/routes`. The reason is that in a future iteration we'd want to extract these to a separate repo. Also, Route specs are simple enough to be generated from a JSON payload if the necessity arises.

### Implementation

The `Routefile` DSL relies on macros, it allows a simpler language for the users. Ultimately it's compiled to a `Plug.Router` with all the benefits, like tree lookup instead of a linear search, etc.

### Routing and Resiliency

The Route is the unit of action to deal with resiliency in Belfrage. There are a few key aspects to consider: 
- **resiliency** - every route is supported by a circuit breaker which keeps track of 200s, 500s etc. If a per-route threshold is reached the circuit breaker will take some corrective actions (reduce load, serve fallback pages, increase TTL, etc). All these kinds of actions can be used depending on the duration and impact of the issue.
- **configuration** - in time we could want to specify different behaviours for specific routes at the entry point.
- **correction** - we could add in the future minor corrections to a specific route through a mechanism similar to the Cosmos Dials like increasing the TTL before some operations, or an election, etc.
- **traffic management** - we could have routes which can produce redirects or point to different layers.

So the unit of action for Belfrage, the one which keeps track of the state of the resource is the route handler (eg: `/sport/clip/:id`) - we considered ways to intercept requests and build the routes definition at runtime but realised it couldn’t scale and adapt properly.

### How to add a route
1. **go** to the `lib/routes/routefiles` dir
2. **add a new matcher** in one of the routefiles depending on which environment you want your route to be available, more info [here](https://github.com/bbc/belfrage/blob/7b66fba6b0efa8c27e896aa1c4d9432a98fbb32f/lib/belfrage_web/routefile_pointer.ex) like:
```elixir
  handle "/sport/videos/:id", using: "SportVideos", examples: ["/sport/videos/49104905"]
```

where:
- `handle "/sport/videos/:id"` is the matcher, it accepts a params as `:id`
- `using: "SportVideos"` is the pointer to the `RouteSpec`
-  `examples: ["/sport/videos/49104905"]` is a list of one or more route examples. This is used by Belfrage for automated testing and documentation.

To restrict the route to test infrastructure, add `only-on: "test"` to the matcher. Test routes are isolated from production and are only created on https://www.belfrage.test.api.bbc.co.uk/

A route matcher can also define validations, like:
```elixir
  handle "/sport/videos/:id", using: "SportVideos", examples: ["/sport/videos/49104905"] do
    return_404 if: String.length(id) != 8
  end
```
where the tenant can define a 404 in case the `id` length is different from 8 chars. 

Check out [Route Matcher Types](route-matcher-types.md) and [Route Validation](route-validation.md) for more details and examples.

3. **add a RouteSpec** in `lib/routes/specs` such as `lib/routes/specs/sport_videos.ex`:
```elixir
defmodule Routes.Specs.SportVideos do
  def specs do
    %{
      owner: "sfv_team@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
      platform: :webcore,
      pipeline: ["HTTPredirect", "LambdaOriginAliasTransformer", "ReplayedTrafficTransformer"],
      resp_pipeline: [],
      query_params_allowlist: ["keyOne", "keyTwo"]
    }
  end
end
```

where:
- `owner` is the email of the owning team
- `runbook` is the link of the tenant page
- `platform` is the platform used
- `pipeline` is a list of zero or more pipeline transformers, which decorate the request or add some business logic to take further decisions for the request (i.e. think a migration business logic process)
- `resp_pipeline` same to decorate/act on the response.
- `query_params_allowlist` valid values are: `"*"` or an array of query string keys to allow. This property is optional, and if not specified, the route defaults to removing the query string from the request.

We plan to add more properties to the RouteSpec while the app evolves.

4. **create a PR** and inform the Belfrage team

### Personalising a route

A route can be configured to support personalisation in order to serve personalised experiences on WebCore. When a request for a personalised route is received, a number of checks are performed. If these checks complete successfully, the user's access token and various attributes are added to the request header for use by the Presentation layer. 

To add support for personalised requests to the route:
1. Add the `personalisation` property to the RouteSpec:
   * Add `personalisation: "on"` to enable personalisation in both live and test.
   * Add `personalisation: "test_only"` to enable personalisation only on test. 
1. Add `"Personalisation"` to the pipeline definition. 

For example:
```elixir
defmodule Routes.Specs.HomePagePersonalised do
  def specs(production_env) do
    %{
      owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/Homepage%20&%20Nations%20-%20WebCore%20-%20Runbook",
      platform: Webcore,
      pipeline: pipeline(production_env),
      personalisation: "on"
    }
  end

  defp pipeline("live") do
    ["HTTPredirect", "TrailingSlashRedirector", "Personalisation", "LambdaOriginAlias", "PlatformKillSwitch", "CircuitBreaker", "Language"]
  end

  defp pipeline(_production_env), do: pipeline("live") ++ ["DevelopmentRequests"]
end
```
For more information, see [Personalisation](../architecture/personalisation.md).

### Further reading

- [Route Matchers](route-matcher-types)
- [Route Validation](route-alidation)