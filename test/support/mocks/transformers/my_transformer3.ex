defmodule Belfrage.RequestTransformers.MyTransformer3 do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(struct = %Struct{}) do
    if 1 == 2 do
      {:ok, struct}
    else
      {:error, struct, "error processing pipeline, I'm doing something specific with this"}
    end
  end
end
