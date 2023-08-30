defmodule Routes.Specs.NewsInPicturesIndex do
  def specification do
    %{
      preflight_pipeline: ["BBCXMozartNewsPlatformSelector"],
      specs: [
        %{
          owner: "DENewsFrameworksTeam@bbc.co.uk",
          runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
          platform: "MozartNews",
          examples: ["/news/in_pictures"]
        },
        %{
          platform: "BBCX",
          examples: ["/news/in_pictures"]
        }
      ]
    }
  end
end