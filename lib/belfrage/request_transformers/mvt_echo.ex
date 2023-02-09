defmodule Belfrage.RequestTransformers.MvtEcho do
  use Belfrage.Behaviours.Transformer

  @json_codec Application.compile_env(:belfrage, :json_codec)

  @impl Transformer
  def call(envelope) do
    {
      :stop,
      Envelope.add(envelope, :response, %{
        http_status: 200,
        headers: %{"content-type" => "application/json", "cache-control" => "public, max-age=5"},
        body: body(envelope)
      })
    }
  end

  defp body(envelope) do
    keys = [:raw_headers, :country, :host, :path]

    Map.take(envelope.request, keys)
    |> Map.put(:datetime, current_datetime())
    |> @json_codec.encode!
  end

  defp current_datetime do
    DateTime.utc_now() |> DateTime.to_string()
  end
end
