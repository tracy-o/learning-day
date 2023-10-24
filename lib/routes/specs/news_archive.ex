defmodule Routes.Specs.NewsArchive do
  def specification do
    %{
      specs: %{
        email: "DENewsFrameworksTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
        platform: "MozartNews",
        examples: ["/news/bigscreen/top_stories/iptvfeed.sjson", "/news/sport1/hi/football/teams/n/newcastle_united/4405841.stm", "/news/2/text_only.stm", "/news/1/shared/spl/hi/uk_politics/03/the_cabinet/html/chancellor_exchequer.stm", "/news/10284448/ticker.sjson"]
      }
    }
  end
end
