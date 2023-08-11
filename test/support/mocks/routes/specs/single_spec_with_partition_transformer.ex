defmodule Routes.Specs.SingleSpecWithPartitionTransformer do
  def specification do
    %{
      preflight_pipeline: ["TestPreflightPartitionTransformer"],
      specs: [
        %{
          owner: "Some guy",
          runbook: "Some runbook",
          platform: "Webcore",
          headers_allowlist: ["webcore-header"],
          query_params_allowlist: ["webcore_qparam"]
        }
      ]
    }
  end
end
