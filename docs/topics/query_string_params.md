## Query String Params in Belfrage

Belfrage allows to define custom allow-lists of query string params. The only query string params that you need to specify are the ones used for server-side rendering purposes.

### Adding Query String Params to your RouteSpecs

You can specify you custom allow-list in your RouteSpec using the `query_params_allowlist` property:

```elixir
defmodule Routes.Specs.Search do
  def specification(production_env) do
    %{
      specs: %{
        owner: "D+ESearchAndNavigationDev@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/x/xo2KD",
        request_pipeline: ["ComToUKRedirect"],
        platform: "Webcore",
        query_params_allowlist: query_params_allowlist(production_env),
        examples: ["/bitesize/search", "/cbbc/search", "/cbeebies/search", "/search"]
      }
    }
  end

  defp query_params_allowlist("live"), do: ["q", "page", "d"]
  defp query_params_allowlist(_production_env), do: query_params_allowlist("live") ++ ["contentenv"]
end
```

If you don't specify an allow-list, your RouteSpec will inherit the one defined in your Platform.

### Avoiding Cache Key Collision

The allow-list is used to build your resources cache keys. By not setting it correctly your query params will not be considered when generating the cache key. As a result, different responses can be cached under the same cache key, leading to incorrect or inconsistent caching behaviours.

### Go Live With New Query String Params

It's extremely important that all the BBC cache layers maintain identical allow lists for a specific route.
When a new query strings get introduced, the belfrage team can assist in requesting similar work in GTM and Fastly. Please create a RESFRAME ticket and sharing it on #help-belfrage, please keep in mind that this tasks will take a few days to reach live.
