defmodule Belfrage.RequestTransformers.TopicRssFeeds do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(envelope) do
    envelope =
      Envelope.add(envelope, :request, %{
        path: "/fd/rss",
        path_params: %{
          "name" => "rss"
        },
        query_params: %{
          "topicId" => envelope.request.path_params["id"],
          "uri" => String.replace(envelope.request.path, "/rss.xml", "")
        },
        raw_headers: %{
          "ctx-unwrapped" => "1"
        }
      })

    {:ok, envelope}
  end
end
