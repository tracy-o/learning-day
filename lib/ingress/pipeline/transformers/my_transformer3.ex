defmodule Ingress.Pipeline.Transformers.MyTransformer3 do
  use Ingress.Pipeline.Transformers.Transformer

  @impl true
  def call(rest, struct) do
    IO.puts("Transformer #{__MODULE__} called")

    {:error, struct, "error processing pipeline, I'm doing something specific with this"}
  end
end
