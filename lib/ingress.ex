defmodule Ingress do
  alias Ingress.{Processor, RequestHash, Struct}

  @callback handle(Struct.t()) :: Struct.t()

  def handle(struct = %Struct{}) do
    struct
    |> Processor.get_loop()
    |> RequestHash.generate()
    |> Processor.request_pipeline()
    |> Processor.perform_call()
    |> Processor.response_pipeline()
  end
end
