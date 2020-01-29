defmodule Belfrage.ResponseTransformers.CompressionAsRequested do
  @moduledoc """
  As we always `gzip` compress the response body in Belfrage's
  internal cache, we need to re-encode it to the format asked
  for by the client.
  """

  alias Belfrage.Struct
  alias Belfrage.Behaviours.ResponseTransformer
  @behaviour ResponseTransformer

  @impl true
  def call(struct = %Struct{request: %Struct.Request{accept_encoding: nil}}) do
    response_headers = Map.delete(struct.response.headers, "content-encoding")
    Struct.add(struct, :response, %{body: :zlib.gunzip(struct.response.body), headers: response_headers})
  end

  @impl true
  def call(struct = %Struct{request: %Struct.Request{accept_encoding: accept_encoding}}) do
    case String.contains?(accept_encoding, "gzip") do
      true ->
        struct

      false ->
        Stump.log(:error, %{
          msg: "Accept-Encoding not supported",
          accept_encoding: accept_encoding
        })
        response_headers = Map.delete(struct.response.headers, "content-encoding")
        Struct.add(struct, :response, %{http_status: 500, headers: response_headers})
    end
  end
end
