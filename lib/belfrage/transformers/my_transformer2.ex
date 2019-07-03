defmodule Ingress.Transformers.MyTransformer2 do
  use Ingress.Transformers.Transformer

  @impl true
  def call(rest, struct = %Struct{}) do
    struct = Map.merge(struct, %{tr2: 2})

    then(rest, struct)
  end
end
