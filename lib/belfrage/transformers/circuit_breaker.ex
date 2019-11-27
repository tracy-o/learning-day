defmodule Belfrage.Transformers.CircuitBreaker do
  use Belfrage.Transformers.Transformer

  @impl true
  def call(rest, struct) do
    struct =
      case threshold_exceeded?(error_count(struct), threshold(struct)) do
        true -> Struct.add(struct, :response, %Belfrage.Struct.Response{http_status: 500})
        false -> struct
      end

    then(rest, struct)
  end

  defp threshold_exceeded?(error_count, threshold) do
    error_count > threshold
  end

  # The origin defined in private is used to fetch :errors inside counter
  # This is used to match the :errors map origin key
  defp error_count(%Struct{private: %{origin: origin, counter: counts}}) do
    parse_count(get_in(counts, [origin, :errors]))
  end

  defp parse_count(nil), do: 0
  defp parse_count(x), do: x

  defp threshold(%Struct{private: %{circuit_breaker_error_threshold: threshold}}), do: threshold
end
