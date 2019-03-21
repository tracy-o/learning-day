defmodule Ingress do
  alias Ingress.{Struct, Loop, LoopsRegistry}

  @callback handle({atom(), Struct}) :: Struct

  def handle({loop_name, _struct = Struct}) do
    LoopsRegistry.find_or_start(loop_name)
    Loop.state(loop_name)

    # Note: In future, this could become something like:

    # struct
    # Processor.add_loop(loop_name)
    # |> Processor.req_transformers()
    # |> Processor.proxy_service()
    # |> Processor.resp_transformers()
  end
end
