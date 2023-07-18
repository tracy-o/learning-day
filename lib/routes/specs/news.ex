defmodule Routes.Specs.News do
  def specification do
    %{
      specs: %{
        owner: "DENewsFrameworksTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
        platform: "MozartNews",
        examples: [
          "/news/special/2015/newsspec_10857/bbc_news_logo.png",
          "/news/resources/idt-d6338d9f-8789-4bc2-b6d7-3691c0e7d138",
          "/news/iptv/scotland/iptvfeed.sjson",
          "/news/extra/3O3eptdEYR/after-the-wall-fell",
          "/news/av-embeds/58869966/vpid/p07r2y68",
          "/news/world-us-canada-15949569"
        ]
      }
    }
  end
end
