defmodule Belfrage.Transformer do
  @request_namespace "Elixir.Belfrage.RequestTransformers"
  @response_namespace "Elixir.Belfrage.ResponseTransformers"

  defmacro __using__(_opts) do
    quote do
      alias Belfrage.Struct
      @behaviour Belfrage.Behaviours.Transformer
      import Belfrage.Transformer
    end
  end

  def then_do([next | rest], struct = %Belfrage.Struct{debug: %{response_pipeline_trail: [first | _]}}) do
    apply(
      String.to_existing_atom(@response_namespace <> "." <> next),
      :call,
      [rest, update_in(struct.debug.response_pipeline_trail, &[next | &1])]
    )
  end

  def then_do([next | rest], struct) do
    apply(
      String.to_existing_atom(@request_namespace <> "." <> next),
      :call,
      [rest, update_in(struct.debug.request_pipeline_trail, &[next | &1])]
    )
  end

  def then_do([], struct), do: {:ok, struct}
end
