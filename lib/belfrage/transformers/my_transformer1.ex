defmodule Ingress.Transformers.MyTransformer1 do
  use Ingress.Transformers.Transformer

  @impl true
  def call(rest, struct = %Struct{}) do
    struct = Map.merge(struct, %{sample_change: "foo"})

    then(rest, struct)
  end
end
