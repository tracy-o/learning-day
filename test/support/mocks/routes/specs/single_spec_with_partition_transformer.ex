defmodule Routes.Specs.SingleSpecWithPartitionTransformer do
  def specification do
    %{
      preflight_pipeline: ["TestPreflightPartitionTransformer"],
      specs: [
        %{
          email: "some@email.com",
          runbook: "Some runbook",
          platform: "Webcore",
          headers_allowlist: ["webcore-header"],
          query_params_allowlist: ["webcore_qparam"]
        }
      ]
    }
  end
end
