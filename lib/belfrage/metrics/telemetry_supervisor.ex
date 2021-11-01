defmodule Belfrage.Metrics.TelemetrySupervisor do
  use Supervisor
  import Telemetry.Metrics

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    children = [
      {
        TelemetryMetricsStatsd,
        metrics: telemetry_metrics(),
        global_tags: [BBCEnvironment: Application.get_env(:belfrage, :production_environment)],
        formatter: :datadog
      }
    ]

    Supervisor.init(children, strategy: :one_for_one, max_restarts: 40)
  end

  defp telemetry_metrics do
    vm_metrics() ++
      cowboy_metrics() ++
      poolboy_metrics() ++
      latency_metrics() ++
      request_metrics()
  end

  defp vm_metrics() do
    [
      last_value("vm.memory.total", unit: {:byte, :kilobyte}, tags: [:BBCEnvironment]),
      last_value("vm.system_counts.process_count", tags: [:BBCEnvironment]),
      last_value("vm.system_counts.atom_count", tags: [:BBCEnvironment]),
      last_value("vm.system_counts.port_count", tags: [:BBCEnvironment]),
      last_value("vm.total_run_queue_lengths.total", tags: [:BBCEnvironment]),
      last_value("vm.total_run_queue_lengths.cpu", tags: [:BBCEnvironment]),
      last_value("vm.total_run_queue_lengths.io", tags: [:BBCEnvironment])
    ]
  end

  defp cowboy_metrics() do
    [
      summary("cowboy.request.stop.duration", unit: {:native, :millisecond}, tags: [:BBCEnvironment]),
      counter("cowboy.request.exception.count", tags: [:BBCEnvironment]),
      counter("cowboy.request.early_error.count", tags: [:BBCEnvironment]),
      counter("cowboy.request.idle_timeout.count",
        event_name: "cowboy.request.stop",
        keep: &match?(%{error: {:connection_error, :timeout, _}}, &1),
        tags: [:BBCEnvironment]
      )
    ]
  end

  defp poolboy_metrics() do
    [
      last_value("poolboy.available_workers.count",
        measurement: :available_workers,
        event_name: "belfrage.poolboy.status",
        tags: [:pool_name, :BBCEnvironment]
      ),
      last_value("poolboy.overflow_workers.count",
        measurement: :overflow_workers,
        event_name: "belfrage.poolboy.status",
        tags: [:pool_name, :BBCEnvironment]
      ),
      last_value("poolboy.pools.max_saturation",
        event_name: "belfrage.poolboy.pools",
        tags: [:BBCEnvironment]
      )
    ]
  end

  defp latency_metrics() do
    Enum.map(
      ~w(
      plug_pipeline
      process_request_headers
      set_request_loop_data
      filter_request_data
      check_if_personalised_request
      generate_request_hash
      fetch_early_response_from_cache
      request_pipeline
      parse_session_token
      pre_cache_compression
      fetch_fallback
      cache_response
      decompress_response
      generate_internal_response
      set_response_headers
      return_json_response
      return_binary_response
    ),
      &latency_metric/1
    )
  end

  defp latency_metric(name) do
    summary("belfrage.latency.#{name}",
      event_name: "belfrage.#{name}.stop",
      measurement: :duration,
      unit: {:native, :microsecond},
      tags: [:BBCEnvironment]
    )
  end

  defp request_metrics() do
    Enum.map(~w(idcta_config jwk), fn name ->
      summary("belfrage.request.#{name}.duration",
        event_name: "belfrage.request.#{name}.stop",
        unit: {:native, :millisecond},
        tags: [:BBCEnvironment]
      )
    end)
  end
end
