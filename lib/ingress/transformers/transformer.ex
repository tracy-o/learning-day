defmodule Ingress.Transformers.Transformer do
  @namespace "Elixir.Ingress.Transformers"

  defmacro __using__(_opts) do
    quote do
      alias Ingress.Struct
      @behaviour Ingress.Behaviours.Transformer
      import Ingress.Transformers.Transformer
    end
  end

  def then([next | rest], struct) do
    next_transformer = String.to_existing_atom(@namespace <> "." <> next)
    struct = update_in(struct.debug.pipeline_trail, &[next | &1])

    apply(next_transformer, :call, [rest, struct])
  end

  def then([], struct) do
    {:ok, struct}
  end
end
