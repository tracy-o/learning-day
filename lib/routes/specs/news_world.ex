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
          platform: "BBCX",
          request_pipeline: ["DomesticToBBCXRedirect"],
          examples: [
            "/news/world",
            "/news/world/africa",
            "/news/world/asia",
            "/news/world/asia/china",
            "/news/world/asia/india",
            "/news/world/australia",
            "/news/world/europe",
            "/news/world/latin_america",
            "/news/world/middle_east",
            %{expected_status: 302, path: "/news/world/us_and_canada"}
          ]
        }
      ]
    }
  end
end
