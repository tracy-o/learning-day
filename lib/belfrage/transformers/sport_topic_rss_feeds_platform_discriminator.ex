defmodule Belfrage.Transformers.SportTopicRssFeedsPlatformDiscriminator do
  @moduledoc """
  Does the mapping between path and topicId.
  Alters the Platform for a subset of Sport RSS feeds that need to be served by FABL.
  """
  use Belfrage.Transformers.Transformer

  @sport_feed_mapping %{
    "/sport/rss.xml" => "c22ymglr3x3t"
  }

  def call(rest, struct) do
    if struct.request.path in Map.keys(@sport_feed_mapping) do
      struct =
        struct
        |> Struct.add(:private, %{
          platform: Fabl,
          origin: Application.get_env(:belfrage, :fabl_endpoint)
        })
        |> Struct.add(:request, %{
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

      then_do(["CircuitBreaker"], struct)
    else
      then_do(rest, struct)
    end
  end
end
