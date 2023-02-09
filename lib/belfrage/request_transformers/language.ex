defmodule Belfrage.RequestTransformers.Language do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.Language

  @impl Transformer
  def call(envelope) do
    {:ok, Belfrage.Envelope.add(envelope, :request, %{language: Language.set(envelope)})}
  end
end
