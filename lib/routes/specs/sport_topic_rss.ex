defmodule Routes.Specs.SportTopicRss do
  def specification do
    %{
      specs: %{
        owner: "#help-sport",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Fabl",
        request_pipeline: ["RssFeedRedirect", "SportTopicRssFeedsMapper"],
        examples: ["/sport/rss.xml", "/sport/scotland/rss.xml", "/sport/football/scottish/rss.xml", "/sport/rugby-union/scottish/rss.xml", "/sport/wales/rss.xml", "/sport/football/welsh/rss.xml", "/sport/rugby-union/welsh/rss.xml", "/sport/northern-ireland/rss.xml", "/sport/football/irish/rss.xml", "/sport/rugby-union/irish/rss.xml", "/sport/northern-ireland/gaelic-games/rss.xml", "/sport/northern-ireland/motorbikes/rss.xml", "/sport/football/world-cup/rss.xml", "/sport/disability-sport/rss.xml", "/sport/winter-sports/rss.xml", "/sport/motorsport/rss.xml", "/sport/american-football/rss.xml", "/sport/basketball/rss.xml", "/sport/boxing/rss.xml", "/sport/golf/rss.xml", "/sport/snooker/rss.xml", "/sport/netball/rss.xml", "/sport/mixed-martial-arts/rss.xml", "/sport/rugby-union/english/rss.xml", "/sport/sports-personality/rss.xml", "/sport/football/european/rss.xml", "/sport/football/european-championship/rss.xml", "/sport/football/fa-cup/rss.xml", "/sport/football/premier-league/rss.xml"]
      }
    }
  end
end
