defmodule Routes.Specs.WorldServiceUkChina do
  def specs do
    %{
      platform: Simorgh,
      pipeline: ["WorldServiceRedirect", "CircuitBreaker"],
      query_params_allowlist: ["alternativeJsLoading", "batch"]
    }
  end
end