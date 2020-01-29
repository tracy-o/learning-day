defmodule Belfrage.ResponseTransformers.PreCacheCompression do
  @moduledoc """
  Ensures we always `gzip` compress the response body in the
  belfrage internal cache.
  """

  alias Belfrage.Struct
  alias Belfrage.Behaviours.ResponseTransformer
  @behaviour ResponseTransformer

  @impl true
  def call(struct = %Struct{response: %Struct.Response{headers: %{"content-encoding" => "gzip"}}}) do
    struct
  end

  @impl true
  def call(struct = %Struct{response: %Struct.Response{headers: %{"content-encoding" => content_encoding}}}) do
    Stump.log(:error, %{
      msg: "Cannot handle compression type",
      content_encoding: content_encoding
    })

    Struct.add(struct, :response, %{body: "", http_status: 415})
  end

  @impl true
  def call(struct) do
    response_headers = Map.put(struct.response.headers, "content-encoding", "gzip")
    Struct.add(struct, :response, %{body: :zlib.gzip(struct.response.body), headers: response_headers})
  end
end
