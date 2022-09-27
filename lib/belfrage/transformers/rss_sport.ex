defmodule Belfrage.Transformers.RssSport do
  @moduledoc """
  Does the mapping between path and topicId.
  Alters the Platform for a subset of Sport RSS feeds that need to be served by FABL.
  """
  use Belfrage.Transformers.Transformer

  @sport_feed_mapping %{
    "/sport/rss.xml" => "c22ymglr3x3t"
  }

  defp get_sport_feed_mapping_keys() do
    Map.keys(@sport_feed_mapping)
  end

  defp get_topic_id(feed_path) do
    Map.get(@sport_feed_mapping, feed_path)
  end

  def call(rest, struct) do
    if struct.request.path in get_sport_feed_mapping_keys() do
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
            "topicId" => get_topic_id(struct.request.path)
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
