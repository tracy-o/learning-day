defmodule Routes.Specs.WorldServiceMarathiHomePageRss do
  def specs do
    %{
      owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
      platform: "Karanga",
      request_pipeline: ["RssFeedDomainValidator"]
    }
  end
end
