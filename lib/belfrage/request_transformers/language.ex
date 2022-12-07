defmodule Belfrage.RequestTransformers.Language do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.Language

  @impl Transformer
  def call(struct) do
    {:ok, Belfrage.Struct.add(struct, :request, %{language: Language.set(struct)})}
  end
end
