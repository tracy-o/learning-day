defmodule Belfrage.RequestTransformers.MyTransformer2 do
  use Belfrage.Transformer

  @impl true
  def call(rest, struct = %Struct{}) do
    struct = Map.merge(struct, %{tr2: 2})

    then_do(rest, struct)
  end
end
