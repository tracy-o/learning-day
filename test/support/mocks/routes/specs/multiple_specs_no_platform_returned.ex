defmodule Routes.Specs.MultipleSpecsNoPlatformReturned do
  def specification do
    %{
      preflight_pipeline: ["TestPreflightPartitionTransformer"],
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
