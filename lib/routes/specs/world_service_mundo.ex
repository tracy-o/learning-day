defmodule Routes.Specs.WorldServiceMundo do
  def specs do
    %{
      platform: Pal,
      pipeline: ["WorldServiceRedirect", "CircuitBreaker"],
      query_params_allowlist: ["alternativeJsLoading", "batch"]
    }
  end

  def smoke_rules(_env) do
    [
      {%{target: "belfrage"}, :redirects_to, ".com"},
      {%{target: "gtm"}, :redirects_to, ".com"},
      {%{target: "bruce"}, :redirects_to, ".com"},
      {%{target: "cedric"}, :redirects_to, ".com"},
      {%{target: "pal"}, :redirects_to, ".com"},
      {%{target: "preview"}, :redirects_to, ".com"}
    ]
  end
end
