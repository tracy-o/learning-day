defmodule Belfrage do
  alias Belfrage.{Processor, Struct}

  @callback handle(Struct.t()) :: Struct.t()

  def handle(struct = %Struct{}) do
    struct
    |> Processor.pre_request_pipeline()
    |> Processor.fetch_early_response_from_cache()
    |> Processor.request_pipeline()
    |> Processor.perform_call()
    |> Processor.response_pipeline()
    |> Processor.post_response_pipeline()
  end
end
