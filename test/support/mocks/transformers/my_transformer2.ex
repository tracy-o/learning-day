defmodule Belfrage.RequestTransformers.MyTransformer2 do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(envelope = %Envelope{}) do
    envelope = Map.merge(envelope, %{tr2: 2})

    {:ok, envelope}
  end
end
