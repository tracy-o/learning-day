defmodule Routes.Specs.WorldServiceNaidheachdan do
  def specs do
    %{
      platform: Simorgh,
      pipeline: ["WorldServiceRedirect", "CircuitBreaker"],
      query_params_allowlist: ["alternativeJsLoading", "batch"],
      default_language: "gd"
    }
  end
end
