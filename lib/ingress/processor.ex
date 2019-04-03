defmodule Ingress.Processor do
  alias Ingress.{LoopsRegistry, Struct, Loop, Transformers}

  def get_loop(struct = %Struct{}) do
    LoopsRegistry.find_or_start(struct)

    with {:ok, loop} <- Loop.state(struct) do
      Struct.Private.put_loop(struct, loop)
    else
      _ -> raise "Failed to start loop."
    end
  end

  def req_pipeline(struct = %Struct{}) do
    Transformers.Transformer.start(struct)
  end

  def proxy_service(struct = %Struct{}) do
    # For now, we are only invoking lambdas
    Ingress.Services.Lambda.dispatch(struct)
  end

  def resp_pipeline(struct = %Struct{}) do
    struct
  end
end
