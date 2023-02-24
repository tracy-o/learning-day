defmodule Belfrage.PreFlightTransformers.TestPreFlightTransformer do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.Envelope

  @impl Transformer
  def call(envelope = %Envelope{}) do
    {:ok, %Envelope{envelope | private: %Envelope.Private{platform: "Webcore"}}}
  end
end
