defmodule Routes.Specs.NewsRealityCheckIndex do
  def specification do
    %{
      preflight_pipeline: ["BBCXMozartNewsPlatformSelector"],
      specs: [
        %{
          owner: "DENewsFrameworksTeam@bbc.co.uk",
          runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
          platform: "MozartNews",
          examples: ["/news/reality_check"]
        },
        %{
          platform: "BBCX",
          examples: ["/news/reality_check"]
        }
      ]
    }
  end
end