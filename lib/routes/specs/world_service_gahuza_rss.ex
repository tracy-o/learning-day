defmodule Routes.Specs.WorldServiceGahuzaRss do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Karanga",
        request_pipeline: ["RssFeedDomainValidator"],
        examples: ["/gahuza/imikino-36980340/rss.xml", "/gahuza/video/umukinnyi/rss.xml"]
      }
    }
  end
end
