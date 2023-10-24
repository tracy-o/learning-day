defmodule Routes.Specs.NewsHomePage do
  def specification do
    %{
      preflight_pipeline: ["BBCXMozartNewsPlatformSelector"],
      specs: [
        %{
          email: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
          platform: "MozartNews",
          fallback_write_sample: 0.5,
          examples: ["/news"]
        },
        %{
          platform: "BBCX",
          fallback_write_sample: 0.5,
          examples: ["/news"]
        }
      ]
    }
  end
end
