defmodule Belfrage.RequestTransformers.Echo do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(envelope) do
    Process.sleep(envelope |> sleep_duration())

    {
      :stop,
      Envelope.add(envelope, :response, %{
        http_status: 200,
        headers: %{},
        body: body_size(envelope)
      })
    }
  end

  # Sleep duration in ms
  defp sleep_duration(envelope) do
    (envelope.request.query_params["latency"] || envelope.request.raw_headers["latency"] || "0")
    |> String.to_integer()
  end

  # Body size in kb
  defp body_size(envelope) do
    input =
      (envelope.request.query_params["size"] || envelope.request.raw_headers["size"] || "0")
      |> String.to_integer()

    if input == 0 do
      """
      Echo Response
      PATH:           #{envelope.request.path}
      PIPELINE:       #{envelope.private.request_pipeline}
      ROUTE_RELEASE:  #{Application.get_env(:belfrage, :route_rel)}
      """
    else
      :crypto.strong_rand_bytes(input * 1024)
      |> Base.encode64()
    end
  end
end
