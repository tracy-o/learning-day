defmodule Routes.Specs.SportRss do
  def specification do
    %{
      specs: %{
        owner: "#help-sport",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Karanga",
        request_pipeline: ["RssFeedRedirect"],
        examples: ["/sport/football/european-championship/2016/rss.xml", "/sport/football/premier-league/rss.xml"]
      }
    }
  end
end
