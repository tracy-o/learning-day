defmodule Belfrage.RequestTransformers.MyTransformer1 do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(struct = %Struct{}) do
    struct = Map.merge(struct, %{sample_change: "foo"})

    {:ok, struct}
  end
end
