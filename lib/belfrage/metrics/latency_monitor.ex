defmodule Belfrage.Metrics.LatencyMonitor do
  alias Belfrage.{Event}

  @valid_checkpoints [
    :request_received,
    :early_response_received,
    :origin_request_sent,
    :origin_response_received,
    :fallback_request_sent,
    :fallback_response_received,
    :response_sent
  ]

  def checkpoint(struct, :response_sent) do
    request_times = get_checkpoints(struct)

    if request_times do
      request_times
      |> Map.put(:response_sent, get_time())
      |> send_metrics()
    end

    struct
  end

  defdelegate get_checkpoints(struct), to: Belfrage.Struct

  def checkpoint(struct, name, time \\ get_time()) when name in @valid_checkpoints do
    Belfrage.Struct.put_checkpoint(struct, name, time)
  end

  defp send_metrics(checkpoints) do
    request = request_latency(checkpoints)
    response = response_latency(checkpoints)

    if request && response do
      :telemetry.execute([:belfrage, :web, :latency, :internal, :request], %{duration: request})
      :telemetry.execute([:belfrage, :web, :latency, :internal, :response], %{duration: response})
      :telemetry.execute([:belfrage, :web, :latency, :internal, :combined], %{duration: request + response})
    end
  end

  defp request_latency(checkpoints) do
    start = checkpoints[:request_received]
    finish = checkpoints[:early_response_received] || checkpoints[:origin_request_sent]

    if start && finish do
      finish - start
    end
  end

  defp response_latency(checkpoints) do
    start = checkpoints[:early_response_received] || checkpoints[:origin_response_received]
    finish = checkpoints[:response_sent]

    if start && finish do
      finish - start - fallback_latency(checkpoints)
    end
  end

  defp fallback_latency(checkpoints) do
    start = checkpoints[:fallback_request_sent]
    finish = checkpoints[:fallback_response_received]

    if start && finish do
      finish - start
    else
      0
    end
  end

  defp get_time(), do: System.monotonic_time(:nanosecond) / 1_000_000
end
