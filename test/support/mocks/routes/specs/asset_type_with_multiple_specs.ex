defmodule Routes.Specs.AssetTypeWithMultipleSpecs do
  def specification do
    %{
      preflight_pipeline: ["AssetTypePlatformSelector"],
      specs: [
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
    }
  end
end
