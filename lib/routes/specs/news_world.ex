defmodule Routes.Specs.NewsWorld do
  def specification do
    %{
      preflight_pipeline: ["BBCXMozartNewsPlatformSelector"],
      specs: [
        %{
          owner: "DENewsFrameworksTeam@bbc.co.uk",
          runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
          platform: "MozartNews",
          examples: ["/news/world", "/news/world/europe", "/news/world/asia/china"]
        },
        %{
          platform: "BBCX"
        }
      ]
    }
  end
end
