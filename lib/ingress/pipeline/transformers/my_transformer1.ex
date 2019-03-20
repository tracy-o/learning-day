defmodule Ingress.Pipeline.Transformers.MyTransformer1 do
  use Ingress.Pipeline.Transformers.Transformer

  @impl true
  def call(rest, struct) do
    IO.puts("Transformer #{__MODULE__} called")

    struct = Map.merge(struct, %{tr1: 1})

    pipe_to(rest, struct)
  end
end
