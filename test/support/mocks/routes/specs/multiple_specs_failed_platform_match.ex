defmodule Routes.Specs.MultipleSpecsFailedPlatformMatch do
  def specification do
    %{
      preflight_pipeline: ["TestPreflightTransformer"],
      specs: [
        %{
          email: "some@email.com",
          runbook: "Some runbook",
          platform: "Simorgh"
        },
        %{
          email: "some@email.com",
          runbook: "Some runbook",
          platform: "MozartNews"
        }
      ]
    }
  end
end
