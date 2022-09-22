defmodule Belfrage.Transformers.Echo do
  use Belfrage.Transformers.Transformer

  @impl true
  def call(_rest, struct) do
    IO.inspect(struct)
    Process.sleep(struct |> sleep_duration())

    {
      :stop_pipeline,
      Struct.add(struct, :response, %{
        http_status: 200,
        headers: %{},
        body: body_size(struct)
      })
    }
  end

  # Sleep duration in ms
  defp sleep_duration(struct) do
    (struct.request.query_params["latency"] || struct.request.raw_headers["latency"] || "0")
    |> String.to_integer()
  end

  # Body size in kb
  defp body_size(struct) do
    input =
      (struct.request.query_params["size"] || struct.request.raw_headers["size"] || "0")
      |> String.to_integer()

    if input == 0 do
      """
      Hey, ho!
      PATH:           #{struct.request.path}
      PIPELINE:       #{struct.private.pipeline}
      ROUTE_RELEASE:  #{Application.get_env(:belfrage, :route_rel)}
      """
    else
      :crypto.strong_rand_bytes(input * 1024)
      |> Base.encode64()
    end
  end
end
