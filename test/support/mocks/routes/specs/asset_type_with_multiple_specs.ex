defmodule Routes.Specs.AssetTypeWithMultipleSpecs do
  def specs do
    [
      %{
        owner: "Some guy",
        runbook: "Some runbook",
        platform: "Webcore"
      },
      %{
        owner: "Some guy",
        runbook: "Some runbook",
        platform: "MozartNews"
      }
    ]
  end

  def preflight_pipeline do
    ["AssetTypePlatformSelector"]
  end
end
