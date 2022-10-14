defmodule Belfrage.RequestTransformers.TopicRssFeeds do
  use Belfrage.Transformer

  def call(rest, struct) do
    struct =
      Struct.add(struct, :request, %{
        path: "/fd/rss",
        path_params: %{
          "name" => "rss"
        },
        query_params: %{
          "topicId" => struct.request.path_params["id"],
          "uri" => String.replace(struct.request.path, "/rss.xml", "")
        },
        raw_headers: %{
          "ctx-unwrapped" => "1"
        }
      })

    then_do(rest, struct)
  end
end
