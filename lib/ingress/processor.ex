defmodule Ingress.Processor do
  alias Ingress.{Struct, Loop}

  def get_loop(struct = Struct) do
    Struct.Private.put_state(struct, Loop.state(struct))
  end
  
  # |> Processor.req_transformers()
  # |> Processor.proxy_service()
  # |> Processor.resp_transformers()
end