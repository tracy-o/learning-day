defmodule Routes.Specs.NewsWorld do
  def specification do
    %{
      specs: %{
        owner: "DENewsFrameworksTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
        platform: "MozartNews",
        examples: ["/news/world/europe", "/news/world-us-canada-15949569"]
      }
    }
  end
end
