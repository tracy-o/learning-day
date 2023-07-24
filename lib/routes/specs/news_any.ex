defmodule Routes.Specs.NewsAny do
  def specification do
    %{
      preflight_pipeline: ["AssetTypePlatformSelector"],
      specs: [
        %{
          owner: "DENewsFrameworksTeam@bbc.co.uk",
          runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
          platform: "MozartNews",
          examples: []
        },
        %{
          owner: "DEWebcoreArticlesCapabilityTeams@bbc.co.uk",
          runbook: "https://confluence.dev.bbc.co.uk/display/NEWSCPSSTOR/News+CPS+Stories+Run+Book",
          platform: "Webcore",
          request_pipeline: [
            "ObitMode"
          ]
        }
      ]
    }
  end
end
