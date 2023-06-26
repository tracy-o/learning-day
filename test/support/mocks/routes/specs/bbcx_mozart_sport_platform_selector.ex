defmodule Routes.Specs.BBCXMozartSportPlatformSelector do
  def specification do
    %{
      preflight_pipeline: ["BBCXMozartSportPlatformSelector"],
      specs: %{
        platform: "MozartSport",
        owner: "Some person",
        runbook: "Some runbook"
      }
    }
  end
end
