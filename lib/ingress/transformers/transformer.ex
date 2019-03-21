defmodule Ingress.Pipeline.Transformers.Transformer do
  @namespace "Elixir.Ingress.Pipeline.Transformers"

  defmacro __using__(_opts) do
    quote do
      @behaviour Ingress.Behaviours.Transformer
      import Ingress.Pipeline.Transformers.Transformer
    end
  end

  def pipe_to([next | rest], struct) do
    next_transformer = String.to_existing_atom(@namespace <> "." <> next)
    struct = update_in(struct, [:debug, :pipeline_tail], &([next | &1]))

    apply(next_transformer, :call, [rest, struct])
  end

  def pipe_to([], struct) do
    {:ok, struct}
  end
end
