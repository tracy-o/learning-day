defmodule Belfrage.RequestTransformers.CircuitBreaker do
  use Belfrage.Behaviours.Transformer

  @dial Application.get_env(:belfrage, :dial)

  @impl Transformer
  def call(struct) do
    case Belfrage.CircuitBreaker.maybe_apply(struct, @dial.state(:circuit_breaker)) do
      {:applied, applied_struct} -> {:stop, applied_struct}
      {:not_applied, not_applied_struct} -> {:ok, not_applied_struct}
    end
  end
end
