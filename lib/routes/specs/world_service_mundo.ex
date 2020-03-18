defmodule Routes.Specs.WorldServiceMundo do
  def specs do
    %{
      platform: Pal,
      pipeline: ["WorldServiceRedirect", "CircuitBreaker"],
      query_params_allowlist: ["alternativeJsLoading", "batch"]
    }
  end
end
