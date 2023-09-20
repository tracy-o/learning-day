defmodule Belfrage.RequestTransformers.WorldServiceTopicRssFeedsMapper do
  @moduledoc """
  Does the mapping between path and topicId.
  Alters the Platform for a subset of World Service RSS feeds that need to be served by FABL.
  """
  use Belfrage.Behaviours.Transformer

  @world_service_rss_feed_mapping %{
    "/afaanoromoo/rss.xml" => "c44dyn08mejt",
    "/amharic/rss.xml" => "cg58k91re1gt",
    "/azeri/rss.xml" => "c1295dq496yt",
    "/bengali/rss.xml" => "cg81xp242zxt",
    "/burmese/rss.xml" => "cn6rql5k0z5t",
    "/gahuza/rss.xml" => "cz4vn9gy9pyt",
    "/gujarati/rss.xml" => "cx0edn859g0t",
    "/igbo/rss.xml" => "cp2dkn6rzj5t",
    "/kyrgyz/rss.xml" => "crg7kj2e52nt",
    "/nepali/rss.xml" => "c44d8kpmzlgt",
    "/marathi/rss.xml" => "crezq2dg90mt",
    "/pidgin/rss.xml" => "ck3yk9nz25qt",
    "/punjabi/rss.xml" => "c0rp0kp5ezmt",
    "/sinhala/rss.xml" => "c1x6gk68neqt",
    "/somali/rss.xml" => "c89m6yjv965t",
    "/tamil/rss.xml" => "c1x6gk68w9zt",
    "/telugu/rss.xml" => "c2w0dk010q2t",
    "/tigrinya/rss.xml" => "cq01ke649v0t",
    "/urdu/rss.xml" => "c44d8kd7lgzt",
    "/yoruba/rss.xml" => "cvpk14mq48kt"
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
