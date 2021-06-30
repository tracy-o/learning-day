defmodule Belfrage.ResponseTransformers.CompressionAsRequested do
  alias Belfrage.Struct
  alias Belfrage.Behaviours.ResponseTransformer
  @behaviour ResponseTransformer

  @impl true
  def call(struct = %Struct{response: %Struct.Response{http_status: http_status}}) when http_status != 200 do
    struct
  end

  @impl true
  def call(
        struct = %Struct{
          request: %Struct.Request{accept_encoding: accept_encoding},
          response: %Struct.Response{http_status: 200}
        }
      ) do
    case should_return_gzip?(accept_encoding) do
      true ->
        struct

      false ->
        response_headers = Map.delete(struct.response.headers, "content-encoding")
        Belfrage.Event.record(:metric, :increment, "web.response.uncompressed")
        Struct.add(struct, :response, %{body: :zlib.gunzip(struct.response.body), headers: response_headers})
    end
  end

  defp should_return_gzip?(nil), do: false
  defp should_return_gzip?(accept_encoding), do: String.contains?(accept_encoding, "gzip")
end
