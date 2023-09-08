defmodule Routes.Specs.WorldServiceMundoRss do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Karanga",
        request_pipeline: ["RssFeedDomainValidator"],
        examples: ["/mundo/internacional/rss.xml", "/mundo/temas/espana/rss.xml"]
      }
    }
  end
end
