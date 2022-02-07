defmodule Belfrage.CircuitBreaker do
  alias Belfrage.Struct
  import Enum, only: [random: 1]

  def maybe_apply(struct, dial_enabled? \\ true) do
    if apply?(struct, dial_enabled?) do
      {:applied, apply(struct)}
    else
      {:not_applied, struct}
    end
  end

  defp apply(struct = %Belfrage.Struct{}) do
    Belfrage.Event.record(:metric, :increment, "circuit_breaker.applied")

    struct
    |> Struct.add(:response, %{http_status: 500})
    |> Struct.add(:private, %{origin: :belfrage_circuit_breaker})
  end

  def threshold_exceeded?(%Struct{
        private: %{origin: origin, long_counter: counts, circuit_breaker_error_threshold: threshold}
      }) do
    error_count(origin, counts) > threshold
  end

  def threshold_exceeded?(%{origin: origin, long_counter: counts, circuit_breaker_error_threshold: threshold}) do
    error_count(origin, counts) > threshold
  end

  defp error_count(origin, counts) do
    parse_count(get_in(counts, [origin, :errors]))
  end

  defp parse_count(x), do: if(x == nil, do: 0, else: x)

  def next_throughput(threshold_exceeded, throughput) when throughput in [0, 20, 60, 100] do
    cond do
      threshold_exceeded -> 0
      max_throughput?(throughput) -> throughput
      true -> increase_throughput(throughput)
    end
  end

  defp increase_throughput(throughput) do
    case throughput do
      0 -> 20
      20 -> 60
      60 -> 100
    end
  end

  defp max_throughput?(throughput) do
    throughput == 100
  end

  defp apply?(struct, dial_enabled?) do
    dial_enabled? and random(1..100) > struct.private.throughput
  end

  def applied?({applied_or_not_applied, _}) do
    case applied_or_not_applied do
      :applied -> true
      :not_applied -> false
    end
  end
end
