defmodule Belfrage.ResponseTransformers.CompressionAsRequested do
  alias Belfrage.{Envelope, Metrics}
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(
        envelope = %Envelope{
          request: %Envelope.Request{accept_encoding: accept_encoding},
          response: %Envelope.Response{headers: headers}
        }
      ) do
    if contains_gzip?(headers["content-encoding"]) && !contains_gzip?(accept_encoding) do
      {:ok, decompress_body(envelope)}
    else
      {:ok, envelope}
    end
  end

  defp contains_gzip?(nil), do: false
  defp contains_gzip?(string), do: String.contains?(string, "gzip")

  defp decompress_body(envelope) do
    Metrics.latency_span(:decompress_response, fn ->
      response_headers = Map.delete(envelope.response.headers, "content-encoding")
      :telemetry.execute([:belfrage, :web, :response, :uncompressed], %{})
      Envelope.add(envelope, :response, %{body: :zlib.gunzip(envelope.response.body), headers: response_headers})
    end)
  end
end
