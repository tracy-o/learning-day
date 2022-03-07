defmodule Belfrage.Transformers.MyTransformer1 do
  use Belfrage.Transformers.Transformer

  @impl true
  def call(rest, struct = %Struct{}) do
    struct = Map.merge(struct, %{sample_change: "foo"})

    then_do(rest, struct)
  end
end
