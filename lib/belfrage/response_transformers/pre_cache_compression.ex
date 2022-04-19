defmodule Belfrage.ResponseTransformers.PreCacheCompression do
  @moduledoc """
  Ensures we always `gzip` compress the response body in the
  belfrage internal cache.
  """
  require Logger

  alias Belfrage.{Struct, Metrics}
  alias Belfrage.Behaviours.ResponseTransformer
  @behaviour ResponseTransformer

  @impl true
  def call(struct = %Struct{response: %Struct.Response{headers: %{"content-encoding" => "gzip"}}}) do
    struct
  end

  @impl true
  def call(struct = %Struct{response: %Struct.Response{headers: %{"content-encoding" => content_encoding}}}) do
    Logger.log(:error, "", %{
      msg: "Cannot handle compression type",
      content_encoding: content_encoding
    })

    Belfrage.Event.record(:metric, :increment, "invalid_content_encoding_from_origin")

    Struct.add(struct, :response, %{body: "", http_status: 415})
  end

  @impl true
  def call(struct = %Struct{response: response = %Struct.Response{}}) do
    if response.http_status == 200 do
      gzip_response_body(struct)
    else
      struct
    end
  end

  defp gzip_response_body(
         struct = %Struct{request: %Struct.Request{path: path}, private: %Struct.Private{platform: platform}}
       ) do
    Metrics.duration(:pre_cache_compression, fn ->
      Belfrage.Event.record(:metric, :increment, "#{platform}.pre_cache_compression")

      Logger.log(:info, "", %{
        msg: "Content was pre-cache compressed",
        path: path,
        platform: platform
      })

      response_headers = Map.put(struct.response.headers, "content-encoding", "gzip")
      Struct.add(struct, :response, %{body: :zlib.gzip(struct.response.body), headers: response_headers})
    end)
  end
end
