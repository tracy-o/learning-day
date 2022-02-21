defmodule Belfrage.Transformers.Language do
  use Belfrage.Transformers.Transformer

  alias Belfrage.Language

  @impl true
  def call(rest, struct) do
    then_do(
      rest,
      Belfrage.Struct.add(struct, :request, %{language: Language.set(struct)})
    )
  end
end
