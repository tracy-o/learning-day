defmodule Routes.Specs.SingleSpecWithPartitionTransformer do
  def specs do
    [
      %{
        owner: "Some guy",
        runbook: "Some runbook",
        platform: "Webcore"
      }
    ]
  end

  def preflight_pipeline do
    ["TestPreflightPartitionTransformer"]
  end
end
