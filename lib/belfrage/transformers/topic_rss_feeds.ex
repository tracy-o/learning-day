defmodule Belfrage.Transformers.TopicRssFeeds do
  use Belfrage.Transformers.Transformer

  def call(rest, struct) do
    struct = Struct.add(struct, :request, %{
      path: "/fd/rss",
      path_params: %{
        "name" => "rss"
      },
      query_params: %{
        "topicId" => struct.request.path_params["id"]
      },
      raw_headers: %{
        "ctx-unwrapped" => "1"
      }
    })

    then_do(rest, struct)
  end
end
