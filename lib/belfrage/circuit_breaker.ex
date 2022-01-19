defmodule Belfrage.CircuitBreaker do
  alias Belfrage.Struct

  def apply?(struct, dial_enabled?) do
    if dial_enabled? and threshold_exceeded?(struct) do
      {:active, active(struct)}
    else
      {:inactive, struct}
    end
  end

  defp active(struct = %Belfrage.Struct{}) do
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

  def next_throughput(threshold_exceeded, throughput) when throughput in [0, 10, 20, 60, 100] do
    cond do
      threshold_exceeded -> 0
      max_throughput?(throughput) -> throughput
      true -> increase_throughput(throughput)
    end
  end

  defp increase_throughput(throughput) do
    case throughput do
      0 -> 10
      10 -> 20
      20 -> 60
      60 -> 100
    end
  end

  defp max_throughput?(throughput) do
    throughput == 100
  end
end
