defmodule Belfrage.Transformers.Language do
  use Belfrage.Transformers.Transformer

  @impl true
  def call(rest, struct) do
    then(rest,
      Belfrage.Struct.add(struct, :request, %{language: struct.private.default_language})
    )
  end
end
