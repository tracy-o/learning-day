defmodule Belfrage.ResponseTransformers.CompressionAsRequested do
  alias Belfrage.Struct
  alias Belfrage.Behaviours.ResponseTransformer
  @behaviour ResponseTransformer

  @impl true
  def call(
        struct = %Struct{
          request: %Struct.Request{accept_encoding: accept_encoding},
          response: %Struct.Response{headers: headers}
        }
      ) do
    with true <- contains_gzip?(headers["content-encoding"]),
         false <- contains_gzip?(accept_encoding) do
      decompress_body(struct)
    else
      _ -> struct
    end
  end

  defp contains_gzip?(nil), do: false
  defp contains_gzip?(string), do: String.contains?(string, "gzip")

  defp decompress_body(struct) do
    response_headers = Map.delete(struct.response.headers, "content-encoding")
    Belfrage.Event.record(:metric, :increment, "web.response.uncompressed")
    Struct.add(struct, :response, %{body: :zlib.gunzip(struct.response.body), headers: response_headers})
  end
end
