defmodule Ingress.Processor do
  alias Ingress.{Struct, Loop}

  def get_loop(struct = Struct) do
    Loop.state(struct.private.loop_id)
  end

  # |> Processor.req_transformers()
  # |> Processor.proxy_service()
  # |> Processor.resp_transformers()
end