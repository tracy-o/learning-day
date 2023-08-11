defmodule Belfrage.ResponseTransformers.ElectoralCommissionResponseHandler do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(envelope = %Envelope{response: response = %Envelope.Response{headers: response_headers}}) do
    cache_directive = %Belfrage.CacheControl{
      cacheability: "public",
      max_age: 5,
      stale_while_revalidate: 30,
      stale_if_error: 90
    }

    envelope =
      Map.put(
        envelope,
        :response,
        %Envelope.Response{response | headers: process_headers(response_headers), cache_directive: cache_directive}
      )

    {:ok, envelope}
  end

  defp process_headers(response_headers) do
    response_headers
    |> Map.delete("vary")
    |> Map.delete("cache-control")
    |> Map.put("cache-control", "public, max-age=5")
  end
end
