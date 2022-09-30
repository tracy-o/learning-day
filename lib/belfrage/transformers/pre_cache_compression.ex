defmodule Belfrage.Transformers.PreCacheCompression do
  @moduledoc """
  Ensures we always `gzip` compress the response body in the
  belfrage internal cache.
  """
  require Logger

  alias Belfrage.{Struct, Metrics}
  use Belfrage.Transformers.Transformer

  @impl true
  def call(rest, struct = %Struct{response: %Struct.Response{headers: %{"content-encoding" => "gzip"}}}) do
    then_do(rest, struct)
  end

  @impl true
  def call(rest, struct = %Struct{response: %Struct.Response{headers: %{"content-encoding" => content_encoding}}}) do
    Logger.log(:error, "", %{
      msg: "Cannot handle compression type",
      content_encoding: content_encoding
    })

    :telemetry.execute([:belfrage, :invalid_content_encoding_from_origin], %{})

    then_do(rest, Struct.add(struct, :response, %{body: "", http_status: 415}))
  end

  @impl true
  def call(rest, struct = %Struct{response: response = %Struct.Response{}}) do
    if response.http_status == 200 and struct.response.body != "" do
      then_do(rest, gzip_response_body(struct))
    else
      then_do(rest, struct)
    end
  end

  defp gzip_response_body(
         struct = %Struct{request: %Struct.Request{path: path}, private: private = %Struct.Private{platform: platform}}
       ) do
    Metrics.latency_span(:pre_cache_compression, fn ->
      Belfrage.Metrics.multi_execute(
        [
          [:belfrage, platform_name(private), :pre_cache_compression],
          [:belfrage, :platform, :pre_cache_compression, :response]
        ],
        %{count: 1},
        %{platform: platform_name(private)}
      )

      Logger.log(:info, "", %{
        msg: "Content was pre-cache compressed",
        path: path,
        platform: platform
      })

      response_headers = Map.put(struct.response.headers, "content-encoding", "gzip")
      Struct.add(struct, :response, %{body: :zlib.gzip(struct.response.body), headers: response_headers})
    end)
  end

  defp platform_name(%Struct.Private{platform: platform}) do
    Module.split(platform) |> hd() |> String.to_atom()
  end
end
