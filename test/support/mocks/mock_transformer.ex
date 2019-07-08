defmodule Belfrage.Transformers.MockTransformer do
  use Belfrage.Transformers.Transformer

  @impl true
  def call(_rest, struct), do: {:ok, struct}
end
