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

  def pre_flight_pipeline do
    ["TestPreFlightPartitionTransformer"]
  end
end
