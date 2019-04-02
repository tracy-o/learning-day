defmodule Ingress.Transformers.MyTransformer3 do
  use Ingress.Transformers.Transformer

  @impl true
  def call(rest, struct) do
    if 1 == 2 do
      then(rest, struct)
    else
      {:error, struct, "error processing pipeline, I'm doing something specific with this"}
    end
  end
end
