defmodule Belfrage.RequestTransformers.MyTransformer1 do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(envelope = %Envelope{}) do
    envelope = Map.merge(envelope, %{sample_change: "foo"})

    {:ok, envelope}
  end
end
