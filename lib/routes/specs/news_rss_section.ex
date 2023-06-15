defmodule Routes.Specs.NewsRssSection do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "MozartNews",
        examples: ["/news/rss/newsonline_uk_edition/front_page/rss.xml"]
      }
    }
  end
end
