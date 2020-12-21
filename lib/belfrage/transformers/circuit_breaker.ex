defmodule Belfrage.Transformers.CircuitBreaker do
  use Belfrage.Transformers.Transformer

  @dial_client Application.get_env(:belfrage, :dial_client)

  @impl true
  def call(rest, struct) do
    case threshold_exceeded?(error_count(struct), threshold(struct)) do
      true ->
        maybe_apply_circuit_breaker(rest, struct, @dial_client.state(:circuit_breaker))

      false ->
        then(rest, struct)
    end
  end

  defp maybe_apply_circuit_breaker(rest, struct, dial_enabled?) do
    case dial_enabled? do
      true -> {:stop_pipeline, circuit_breaker_active(struct)}
      false -> then(rest, struct)
    end
  end

  defp circuit_breaker_active(struct = %Belfrage.Struct{}) do
    Belfrage.Event.record(:metric, :increment, "circuit_breaker.active")

    struct
    |> Struct.add(:response, %{http_status: 500})
    |> Struct.add(:private, %{origin: :belfrage_circuit_breaker})
  end

  defp threshold_exceeded?(error_count, threshold), do: error_count > threshold

  # The origin defined in private is used to fetch :errors inside long_counter
  # This is used to match the :errors map origin key
  defp error_count(%Struct{private: %{origin: origin, long_counter: counts}}) do
    parse_count(get_in(counts, [origin, :errors]))
  end

  defp parse_count(nil), do: 0
  defp parse_count(x), do: x

  defp threshold(%Struct{private: %{circuit_breaker_error_threshold: threshold}}), do: threshold
end
