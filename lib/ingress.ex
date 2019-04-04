defmodule Ingress do
  alias Ingress.{Processor, Struct}

  @callback handle(Struct) :: Struct

  def handle(struct = %Struct{}) do
    struct
    |> Processor.get_loop()
    |> Processor.req_pipeline()
    |> Processor.proxy_service()
    |> Processor.resp_pipeline()
  end
end
