defmodule Belfrage.RequestTransformers.MyTransformer2 do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(struct = %Struct{}) do
    struct = Map.merge(struct, %{tr2: 2})

    {:ok, struct}
  end
end
