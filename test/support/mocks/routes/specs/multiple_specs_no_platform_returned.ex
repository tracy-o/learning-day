defmodule Routes.Specs.MultipleSpecsNoPlatformReturned do
  def specification do
    %{
      preflight_pipeline: ["TestPreflightPartitionTransformer"],
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
