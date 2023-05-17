defmodule Routes.Specs.SingleSpecWithPartitionTransformer do
  def specification do
    %{
      preflight_pipeline: ["TestPreflightPartitionTransformer"],
      specs: [
        %{
          owner: "Some guy",
          runbook: "Some runbook",
          platform: "Webcore"
        }
      ]
    }
  end
end
