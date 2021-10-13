defmodule Belfrage do
  alias Belfrage.{Processor, Struct, Cascade}
  alias Belfrage.Struct.{Request, Response}
  alias Belfrage.Metrics.LatencyMonitor

  @callback handle(Struct.t()) :: Struct.t()

  def handle(struct = %Struct{}) do
    struct
    |> Cascade.build()
    |> Cascade.fan_out(fn struct ->
      struct
      |> prepare_request()
      |> check_cache()
    end)
    |> generate_response()
  end

  defp prepare_request(struct) do
    struct
    |> Processor.get_loop()
    |> Processor.allowlists()
    |> Processor.personalisation()
    |> Processor.generate_request_hash()
  end

  defp check_cache(struct), do: Processor.fetch_early_response_from_cache(struct)

  defp generate_response(struct = %Struct{request: request = %Request{}, response: %Response{http_status: http_status}})
       when http_status != nil do
    LatencyMonitor.checkpoint(request.request_id, :early_response_received)

    struct
    |> Processor.inc_loop()
    |> Processor.init_post_response_pipeline()
  end

  defp generate_response(structs) do
    structs
    |> Cascade.fan_out(&Processor.request_pipeline/1)
    |> Cascade.dispatch()
    |> Processor.inc_loop()
    |> Processor.response_pipeline()
    |> Processor.init_post_response_pipeline()
    |> Processor.inc_loop_on_fallback()
  end
end
