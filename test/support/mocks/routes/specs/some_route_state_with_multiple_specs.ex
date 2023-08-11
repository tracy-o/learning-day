defmodule Routes.Specs.SomeRouteStateWithMultipleSpecs do
  def specification do
    %{
      preflight_pipeline: ["TestPreflightTransformer"],
      specs: [
        %{
          owner: "Some guy",
          runbook: "Some runbook",
          platform: "Webcore",
          query_params_allowlist: ["webcore_qparam"],
          headers_allowlist: ["webcore-header"]
        },
        %{
          owner: "Some guy",
          runbook: "Some runbook",
          platform: "MozartNews",
          query_params_allowlist: "*",
          headers_allowlist: ["mozartnews-header"]
        }
      ]
    }
  end
end
