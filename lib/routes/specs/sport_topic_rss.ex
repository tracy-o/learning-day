defmodule Routes.Specs.SportTopicRss do
  def specification do
    %{
      specs: %{
        owner: "#help-sport",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Fabl",
        request_pipeline: ["RssFeedRedirect", "SportTopicRssFeedsMapper"],
        examples: ["/sport/rss.xml"]
      }
    }
  end
end
