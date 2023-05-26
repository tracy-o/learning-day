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

  def preflight_pipeline do
    ["TestPreflightTransformer"]
  end
end
