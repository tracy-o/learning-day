defmodule Routes.Specs.SomeRouteStateWithMultipleSpecs do
  def specification do
    %{
      preflight_pipeline: ["TestPreflightTransformer"],
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
