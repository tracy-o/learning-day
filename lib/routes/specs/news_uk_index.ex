defmodule Routes.Specs.NewsUkIndex do
  def specification do
    %{
      preflight_pipeline: ["BBCXMozartNewsPlatformSelector"],
      specs: [
        %{
          email: "DENewsFrameworksTeam@bbc.co.uk",
          runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
          platform: "MozartNews",
          examples: ["/news/uk"]
        },
        %{
          platform: "BBCX",
          examples: ["/news/uk"]
        }
      ]
    }
  end
end
