defmodule Ingress.Pipeline.Transformers.Transformer do
  defmacro __using__(_opts) do
    quote do
      @behaviour Ingress.Behaviours.Transformer
      import Ingress.Pipeline.Transformers.Transformer
    end
  end

  def pipe_to([next | rest], struct) do
    mod = String.to_existing_atom("Elixir.Ingress.Pipeline.Transformers.#{next}")

    apply(mod, :call, [rest, struct])
  end

  def pipe_to([], struct) do
    {:ok, struct}
  end
end
