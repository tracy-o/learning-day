defmodule Belfrage.RequestTransformers.MvtEcho do
  use Belfrage.Behaviours.Transformer

  @json_codec Application.get_env(:belfrage, :json_codec)

  @impl Transformer
  def call(struct) do
    {
      :stop,
      Struct.add(struct, :response, %{
        http_status: 200,
        headers: %{"content-type" => "application/json", "cache-control" => "public, max-age=5"},
        body: body(struct)
      })
    }
  end

  defp body(struct) do
    keys = [:raw_headers, :country, :host, :path]

    Map.take(struct.request, keys)
    |> Map.put(:datetime, current_datetime())
    |> @json_codec.encode!
  end

  defp current_datetime do
    DateTime.utc_now() |> DateTime.to_string()
  end
end
