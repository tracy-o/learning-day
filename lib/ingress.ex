defmodule Ingress do
  alias Ingress.{Struct, Loop, LoopsRegistry}

  @callback handle(Struct) :: Struct

  def handle(struct = Struct) do
    LoopsRegistry.find_or_start(struct.private.loop_id)
    Loop.state(struct.private.loop_id)

    # Note: In future, this could become something like:

    # struct
    # Processor.get_loop()
    # |> Processor.req_transformers()
    # |> Processor.proxy_service()
    # |> Processor.resp_transformers()
  end
end
