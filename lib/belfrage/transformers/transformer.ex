defmodule Belfrage.Transformers.Transformer do
  @namespace "Elixir.Belfrage.Transformers"

  defmacro __using__(_opts) do
    quote do
      alias Belfrage.Struct
      @behaviour Belfrage.Behaviours.Transformer
      import Belfrage.Transformers.Transformer
    end
  end

  def then([:_routespec_pipeline_placeholder | rest], struct) do
    then(rest, struct)
  end

  def then([next | rest], struct) do
    apply(
      String.to_existing_atom(@namespace <> "." <> next),
      :call,
      [rest, update_in(struct.debug.pipeline_trail, &[next | &1])]
    )
  end

  def then([], struct), do: {:ok, struct}
end
