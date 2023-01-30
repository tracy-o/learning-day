defmodule Routes.Specs.SomeRouteStateWithMultipleSpecs do
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
end
