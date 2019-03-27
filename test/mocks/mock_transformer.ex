defmodule Ingress.Transformers.MockTransformer do
  use Ingress.Transformers.Transformer

  @impl true
  def call(_rest, struct), do: {:ok, struct}
end
