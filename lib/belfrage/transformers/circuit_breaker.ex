defmodule Belfrage.Transformers.CircuitBreaker do
  use Belfrage.Transformers.Transformer

  @dial Application.get_env(:belfrage, :dial)

  @impl true
  def call(rest, struct) do
    case Belfrage.CircuitBreaker.apply_circuit_breaker?(struct, @dial.state(:circuit_breaker)) do
      {:active, active_struct} -> {:stop_pipeline, active_struct}
      {:inactive, inactive_struct} -> then(rest, inactive_struct)
    end
  end
end
