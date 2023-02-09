defmodule Belfrage.RequestTransformers.SportTopicRssFeedsMapper do
  @moduledoc """
  Does the mapping between path and topicId.
  Alters the Platform for a subset of Sport RSS feeds that need to be served by FABL.
  """
  use Belfrage.Behaviours.Transformer

  @sport_feed_mapping %{
    "/sport/rss.xml" => "c22ymglr3x3t"
  }

  @impl Transformer
  def call(envelope) do
    envelope =
      Envelope.add(envelope, :request, %{
        path: "/fd/rss",
        path_params: %{
          "name" => "rss"
        },
        query_params: %{
          "topicId" => Map.get(@sport_feed_mapping, envelope.request.path),
          "uri" => String.replace(envelope.request.path, "/rss.xml", "")
        },
        raw_headers: %{
          "ctx-unwrapped" => "1"
        }
      })

    {:ok, envelope}
  end
end
