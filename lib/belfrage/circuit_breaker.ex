defmodule Belfrage.CircuitBreaker do
  alias Belfrage.{Envelope, RouteState}
  import Enum, only: [random: 1]

  def maybe_apply(envelope, dial_enabled? \\ true) do
    if apply?(envelope, dial_enabled?) do
      {:applied, apply(envelope)}
    else
      {:not_applied, envelope}
    end
  end

  defp apply(envelope = %Belfrage.Envelope{}) do
    metadata = RouteState.map_id(envelope.private.route_state_id)
    Belfrage.Metrics.event(~w(circuit_breaker applied)a, metadata)

    envelope
    |> Envelope.add(:response, %{http_status: 500})
    |> Envelope.add(:private, %{origin: :belfrage_circuit_breaker})
  end

  def threshold_exceeded?(%Envelope{
        private: %{origin: origin, counter: counts, circuit_breaker_error_threshold: threshold}
      }) do
    error_count(origin, counts) > threshold
  end

  def threshold_exceeded?(%{origin: origin, counter: counts, circuit_breaker_error_threshold: threshold}) do
    error_count(origin, counts) > threshold
  end

  defp error_count(origin, counts) do
    parse_count(get_in(counts, [origin, :errors]))
  end

  defp parse_count(x), do: if(x == nil, do: 0, else: x)

  def next_throughput(_threshold_exceeded, _throughput, false), do: 100

  def next_throughput(threshold_exceeded, throughput, _dial_enabled?) when throughput in [0, 20, 60, 100] do
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

  defp apply?(envelope, dial_enabled?) do
    dial_enabled? and random(1..100) > envelope.private.throughput
  end

  def applied?({applied_or_not_applied, _}) do
    case applied_or_not_applied do
      :applied -> true
      :not_applied -> false
    end
  end
end
