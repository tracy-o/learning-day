defmodule Routes.Specs.NewsTechnologyIndex do
  def specification do
    %{
      preflight_pipeline: ["BBCXMozartNewsPlatformSelector"],
      specs: [
        %{
          owner: "DENewsFrameworksTeam@bbc.co.uk",
          runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
          platform: "MozartNews",
          examples: ["/news/technology"]
        },
        %{
          platform: "BBCX",
          request_pipeline: ["DomesticToBBCXRedirect"],
          examples: [
            %{expected_status: 302, path: "/news/technology"},
          ]
        }
      ]
    }
  end
end
