defmodule Belfrage.RequestTransformers.WorldServiceTopicRssFeedsMapper do
  @moduledoc """
  Does the mapping between path and topicId.
  Alters the Platform for a subset of World Service RSS feeds that need to be served by FABL.
  """
  use Belfrage.Behaviours.Transformer

  @world_service_rss_feed_mapping %{
    "/azeri/rss.xml" => "c1295dq496yt",
    "/burmese/rss.xml" => "cn6rql5k0z5t",
    "/gujarati/rss.xml" => "cx0edn859g0t",
    "/igbo/rss.xml" => "cp2dkn6rzj5t",
    "/kyrgyz/rss.xml" => "crg7kj2e52nt",
    "/pidgin/rss.xml" => "ck3yk9nz25qt"
  }

  defp migrated_rss_feed?(path) do
    Map.has_key?(@world_service_rss_feed_mapping, path)
  end

  @impl Transformer
  def call(envelope) do
    if migrated_rss_feed?(envelope.request.path) do
      envelope =
        Envelope.add(envelope, :request, %{
          path: "/fd/rss",
          path_params: %{
            "name" => "rss"
          },
          query_params: %{
            "topicId" => Map.get(@world_service_rss_feed_mapping, envelope.request.path),
            "uri" => String.replace(envelope.request.path, "/rss.xml", "")
          },
          raw_headers: %{
            "ctx-unwrapped" => "1"
          }
        })

      {:ok, envelope}
    else
      {:ok, envelope}
    end
  end
end
