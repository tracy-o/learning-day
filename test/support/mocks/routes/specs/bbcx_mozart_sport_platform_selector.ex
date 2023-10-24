defmodule Routes.Specs.BBCXMozartSportPlatformSelector do
  def specification do
    %{
      preflight_pipeline: ["BBCXMozartSportPlatformSelector"],
      specs: [
        %{
          platform: "MozartSport",
          email: "some@email.com",
          runbook: "Some runbook"
        },
        %{
          platform: "BBCX",
          email: "some@email.com",
          runbook: "Some runbook"
        }
      ]
    }
  end
end
