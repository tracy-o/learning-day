defmodule Routes.Specs.MultipleSpecsFailedPlatformMatch do
  def specs do
    [
      %{
        owner: "Some guy",
        runbook: "Some runbook",
        platform: "Simorgh"
      },
      %{
        owner: "Some guy",
        runbook: "Some runbook",
        platform: "MozartNews"
      }
    ]
  end

  def pre_flight_pipeline do
    ["TestPreFlightTransformer"]
  end
end
