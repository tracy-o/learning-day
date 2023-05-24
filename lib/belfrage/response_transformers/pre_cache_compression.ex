defmodule Belfrage.ResponseTransformers.PreCacheCompression do
  @moduledoc """
  Ensures we always `gzip` compress the response body in the
  belfrage internal cache.
  """
  require Logger

  alias Belfrage.{Envelope, Envelope.Response, Envelope.Private, Metrics}
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(envelope = %Envelope{response: %Response{headers: %{"content-encoding" => "gzip"}}}) do
    {:ok, envelope}
  end

  def call(
        envelope = %Envelope{
          response: %Response{headers: %{"content-encoding" => content_encoding}},
          private: %Private{spec: route_spec, platform: platform, partition: partition}
        }
      ) do
    Logger.log(:error, "", %{
      msg: "Cannot handle compression type",
      content_encoding: content_encoding
    })

    :telemetry.execute([:belfrage, :invalid_content_encoding_from_origin], %{}, %{
      route_spec: route_spec,
      platform: platform,
      partition: partition
    })

    {:ok, Envelope.add(envelope, :response, %{body: "", http_status: 415})}
  end

  def call(envelope = %Envelope{response: response = %Envelope.Response{}}) do
    if response.http_status == 200 and envelope.response.body != "" do
      {:ok, gzip_response_body(envelope)}
    else
      {:ok, envelope}
    end
  end

  defp gzip_response_body(
         envelope = %Envelope{
           request: %Envelope.Request{path: path},
           private: private = %Envelope.Private{spec: route_spec, platform: platform, partition: partition}
         }
       ) do
    Metrics.latency_span(:pre_cache_compression, fn ->
      Belfrage.Metrics.multi_execute(
        [
          [:belfrage, platform_name(private), :pre_cache_compression],
          [:belfrage, :platform, :pre_cache_compression, :response]
        ],
        %{count: 1},
        %{route_spec: route_spec, platform: platform, partition: partition}
      )

      Logger.log(:info, "", %{
        msg: "Content was pre-cache compressed",
        path: path,
        platform: platform
      })

      response_headers = Map.put(envelope.response.headers, "content-encoding", "gzip")
      Envelope.add(envelope, :response, %{body: :zlib.gzip(envelope.response.body), headers: response_headers})
    end)
  end

  defp platform_name(%Envelope.Private{platform: platform}) do
    platform |> String.to_atom()
  end
end
