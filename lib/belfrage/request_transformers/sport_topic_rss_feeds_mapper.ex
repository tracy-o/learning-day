defmodule Belfrage.RequestTransformers.SportTopicRssFeedsMapper do
  @moduledoc """
  Does the mapping between path and topicId.
  Alters the Platform for a subset of Sport RSS feeds that need to be served by FABL.
  """
  use Belfrage.Transformer

  @sport_feed_mapping %{
    "/sport/rss.xml" => "c22ymglr3x3t"
  }

  def call(rest, struct) do
    struct =
      Struct.add(struct, :request, %{
        path: "/fd/rss",
        path_params: %{
          "name" => "rss"
        },
        query_params: %{
          "topicId" => Map.get(@sport_feed_mapping, struct.request.path),
          "uri" => String.replace(struct.request.path, "/rss.xml", "")
        },
        raw_headers: %{
          "ctx-unwrapped" => "1"
        }
      })

    then_do(rest, struct)
  end
end
