defmodule Belfrage.RequestTransformers.MyTransformer3 do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(envelope = %Envelope{}) do
    if 1 == 2 do
      {:ok, envelope}
    else
      {:error, envelope, "error processing pipeline, I'm doing something specific with this"}
    end
  end
end
