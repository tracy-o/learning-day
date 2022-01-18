defmodule Belfrage.CircuitBreaker do
  alias Belfrage.Struct

  def apply_circuit_breaker?(struct, dial_enabled?) do
    if dial_enabled? and threshold_exceeded?(struct) do
      {:active, circuit_breaker_active(struct)}
    else
      {:inactive, struct}
    end
  end

  defp circuit_breaker_active(struct = %Belfrage.Struct{}) do
    Belfrage.Event.record(:metric, :increment, "circuit_breaker.active")

    struct
    |> Struct.add(:response, %{http_status: 500})
    |> Struct.add(:private, %{origin: :belfrage_circuit_breaker})
  end

  defp threshold_exceeded?(struct = %Belfrage.Struct{}) do
    error_count(struct) > struct.private.circuit_breaker_error_threshold
  end

  defp error_count(%Struct{private: %{origin: origin, long_counter: counts}}) do
    parse_count(get_in(counts, [origin, :errors]))
  end

  defp parse_count(x), do: if(x == nil, do: 0, else: x)
end
