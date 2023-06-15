defmodule Routes.Specs.WorldServiceZhongwenTopicRss do
  def specification do
    %{
      specs: %{
        owner: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BBCHOME/RSS+Feeds+-+WebCore+-+Runbook",
        platform: "Fabl",
        request_pipeline: ["RssFeedDomainValidator", "TopicRssFeeds"],
        examples: ["/zhongwen/trad/topics/cpydz21p02et/rss.xml", "/zhongwen/simp/topics/c0dg90z8nqxt/rss.xml"]
      }
    }
  end
end
