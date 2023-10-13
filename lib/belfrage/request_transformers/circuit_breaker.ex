defmodule Belfrage.RequestTransformers.CircuitBreaker do
  use Belfrage.Behaviours.Transformer

  @dial Application.compile_env(:belfrage, :dial)

  @impl Transformer
  def call(envelope) do
    case Belfrage.CircuitBreaker.maybe_apply(envelope, @dial.get_dial(:circuit_breaker)) do
      {:applied, applied_envelope} -> {:stop, applied_envelope}
      {:not_applied, not_applied_envelope} -> {:ok, not_applied_envelope}
    end
  end
end
