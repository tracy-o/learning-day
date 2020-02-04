defmodule Belfrage.ResponseTransformers.CompressionAsRequested do
  @behaviour ResponseTransformer

  alias Belfrage.Struct
  alias Belfrage.Behaviours.ResponseTransformer

  @impl true
  def call(struct = %Struct{request: %Struct.Request{accept_encoding: accept_encoding}}) do
    case should_return_gzip?(accept_encoding) do
      true -> struct
      false ->
        response_headers = Map.delete(struct.response.headers, "content-encoding")
        Struct.add(struct, :response, %{body: :zlib.gunzip(struct.response.body), headers: response_headers})
    end
  end

  defp should_return_gzip?(nil), do: false
  defp should_return_gzip?(accept_encoding), do: String.contains?(accept_encoding, "gzip")
end
