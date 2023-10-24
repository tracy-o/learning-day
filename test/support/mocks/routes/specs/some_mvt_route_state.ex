defmodule Routes.Specs.SomeMvtRouteState do
  def specification do
    %{
      specs: %{
        email: "some@email.com",
        runbook: "Some runbook",
        platform: "Webcore",
        caching_enabled: true,
        mvt_project_id: 1
      }
    }
  end
end
