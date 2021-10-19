defmodule Belfrage do
  alias Belfrage.{Processor, Struct, Cascade}

  @callback handle(Struct.t()) :: Struct.t()

  def handle(struct = %Struct{}) do
    struct
    |> Cascade.build()
    |> Cascade.fan_out(fn struct ->
      struct
      |> Processor.pre_request_pipeline()
      |> Processor.fetch_early_response_from_cache()
    end)
    |> Cascade.result_or(&no_cached_response/1)
    |> Processor.post_response_pipeline()
  end

  defp no_cached_response(cascade) do
    cascade
    |> Cascade.fan_out(&Processor.request_pipeline/1)
    |> Cascade.result_or(&Cascade.dispatch/1)
    |> Processor.response_pipeline()
  end
end
