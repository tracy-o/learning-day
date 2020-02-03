defmodule Belfrage.Transformers.CircuitBreaker do
  use Belfrage.Transformers.Transformer

  @impl true
  def call(rest, struct) do
    struct =
      case threshold_exceeded?(error_count(struct), threshold(struct)) do
        true -> 
          circuit_breaker_active(struct)
        false -> struct
      end

    then(rest, struct)
  end

  defp circuit_breaker_active(struct = %Belfrage.Struct{}) do
    ExMetrics.increment("circuit_breaker.active")

    struct
    |> Struct.add(:response, %{http_status: 500})
    |> Struct.add(:private, %{origin: :belfrage_circuit_breaker})
  end

  defp threshold_exceeded?(error_count, threshold) do
    error_count > threshold
  end

  # The origin defined in private is used to fetch :errors inside long_counter
  # This is used to match the :errors map origin key
  defp error_count(%Struct{private: %{origin: origin, long_counter: counts}}) do
    parse_count(get_in(counts, [origin, :errors]))
  end

  defp parse_count(nil), do: 0
  defp parse_count(x), do: x

  defp threshold(%Struct{private: %{circuit_breaker_error_threshold: threshold}}), do: threshold
end