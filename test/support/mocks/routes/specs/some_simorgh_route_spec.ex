defmodule Routes.Specs.SomeSimorghRouteSpec do
  def specification do
    %{
      specs: %{
        slack_channel: "#some-channel",
        runbook: "Some runbook",
        platform: "Simorgh",
        mvt_project_id: 2
      }
    }
  end
end
