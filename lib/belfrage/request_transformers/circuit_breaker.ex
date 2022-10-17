defmodule Belfrage.RequestTransformers.CircuitBreaker do
  use Belfrage.Transformer

  @dial Application.get_env(:belfrage, :dial)

  @impl true
  def call(rest, struct) do
    case Belfrage.CircuitBreaker.maybe_apply(struct, @dial.state(:circuit_breaker)) do
      {:applied, applied_struct} -> {:stop_pipeline, applied_struct}
      {:not_applied, not_applied_struct} -> then_do(rest, not_applied_struct)
    end
  end
end