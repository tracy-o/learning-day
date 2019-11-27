defmodule Belfrage.Transformers.CircuitBreaker do
  use Belfrage.Transformers.Transformer

  @impl true
  def call(rest, struct) do
    struct =
      with true <- circuit_breaker_config_valid?(struct),
           true <- threshold_exceeded?(error_count(struct), threshold(struct)) do
        Struct.add(struct, :response, %Belfrage.Struct.Response{http_status: 500})
      else
        false ->
          log_invalid_config(struct)
          struct
      end

    then(rest, struct)
  end

  defp circuit_breaker_config_valid?(%Struct{private: %{circuit_breaker_error_threshold: _threshold}}), do: true
  defp circuit_breaker_config_valid?(_), do: false

  defp threshold_exceeded?(error_count, threshold) do
    error_count > threshold
  end

  defp error_count(%Struct{private: %{origin: origin, counter: counts}}) do
    parse_count(get_in(counts, [origin, :errors]))
  end

  defp parse_count(nil), do: 0
  defp parse_count(x), do: x

  defp threshold(%Struct{private: %{circuit_breaker_error_threshold: threshold}}), do: threshold

  defp log_invalid_config(%Struct{private: %{loop_id: id}}) do
    Stump.log(:error, %{
      msg: "Invalid config specific for circuit breaker",
      loop_id: id
    })
  end
end
