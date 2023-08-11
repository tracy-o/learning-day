defmodule Routes.Specs.MultipleSpecsFailedPlatformMatch do
  def specification do
    %{
      preflight_pipeline: ["TestPreflightTransformer"],
      specs: [
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
    }
  end
end
