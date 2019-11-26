defmodule Belfrage.Transformers.CircuitBreaker do
  use Belfrage.Transformers.Transformer

  @impl true
  def call(rest, struct) do
    struct = response_override_if_circuit_breaker_triggered(struct)

    then(rest, struct)
  end

  defp response_override_if_circuit_breaker_triggered(struct) do
    case threshold_exceeded?(error_count(struct), threshold(struct)) do
      true -> Struct.add(struct, :response, %Belfrage.Struct.Response{http_status: 500})
      false -> struct
    end
  end

  defp threshold_exceeded?(error_count, threshold) do
    error_count >= threshold
  end

  defp error_count(%Struct{private: %{origin: origin, counter: counts}} = struct) do
    parse_count(get_in(counts, [origin, :errors]))
  end

  defp parse_count(nil), do: 0
  defp parse_count(x), do: x

  # @todo: use threshold from struct
  defp threshold(_struct) do
    2
  end
end
