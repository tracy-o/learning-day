defmodule Routes.Specs.NewsWebcoreIndex do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/DPTOPICS/Topics+Runbook",
        platform: "Webcore",
        examples: [
          "/news/the_reporters",
          "/news/stories",
          "/news/have_your_say",
          "/news/election/us2016",
          "/news/election/ni2017",
          "/news/election/2017",
          "/news/election/2016/wales",
          "/news/election/2016/scotland",
          "/news/election/2016/northern_ireland",
          "/news/election/2016/london",
          "/news/election/2016",
          "/news/election/2015/scotland",
          "/news/election/2015/wales",
          "/news/election/2015/northern_ireland",
          "/news/election/2015/england",
          "/news/election/2015"
        ]
      }
    }
  end
end