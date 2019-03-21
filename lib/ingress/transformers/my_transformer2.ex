defmodule Ingress.Pipeline.Transformers.MyTransformer2 do
  use Ingress.Pipeline.Transformers.Transformer

  @impl true
  def call(rest, struct) do
    IO.puts("Transformer #{__MODULE__} called")

    struct = Map.merge(struct, %{tr2: 2})

    pipe_to(rest, struct)
  end
end
