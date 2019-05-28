defmodule Ingress do
  alias Ingress.{Processor, Struct}

  @callback handle(Struct.t()) :: Struct.t()

  def handle(struct = %Struct{}) do
    struct
    |> Processor.get_loop()
    |> Processor.generate_request_hash()
    |> Processor.request_pipeline()
    |> Processor.perform_call()
    |> Processor.response_pipeline()
  end
end
