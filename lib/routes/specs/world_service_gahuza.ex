defmodule Routes.Specs.WorldServiceGahuza do
  def specs do
    %{
      platform: Mozart,
      pipeline: ["WorldServiceRedirect", "CircuitBreaker"],
      query_params_allowlist: ["alternativeJsLoading", "batch"]
    }
  end
end
