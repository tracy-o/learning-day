defmodule Belfrage.Metrics.TelemetrySupervisor do
  use Supervisor
  import Telemetry.Metrics

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    children = [
      {TelemetryMetricsStatsd, metrics: telemetry_metrics()}
    ]

    Supervisor.init(children, strategy: :one_for_one, max_restarts: 40)
  end

  defp telemetry_metrics do
    [
      last_value("vm.memory.total", unit: {:byte, :kilobyte}),
      last_value("vm.system_counts.process_count"),
      last_value("vm.system_counts.atom_count"),
      last_value("vm.system_counts.port_count"),
      last_value("vm.total_run_queue_lengths.total"),
      last_value("vm.total_run_queue_lengths.cpu"),
      last_value("vm.total_run_queue_lengths.io"),
      summary("cowboy.request.stop.duration", unit: {:native, :millisecond}),
      counter("cowboy.request.exception.count"),
      counter("cowboy.request.early_error.count"),
      counter("cowboy.request.idle_timeout.count",
        event_name: "cowboy.request.stop",
        keep: &match?(%{error: {:connection_error, :timeout, _}}, &1)
      ),
      last_value("poolboy.available_workers.count",
        measurement: :available_workers,
        event_name: "belfrage.poolboy.status",
        tags: [:pool_name]
      ),
      last_value("poolboy.overflow_workers.count",
        measurement: :overflow_workers,
        event_name: "belfrage.poolboy.status",
        tags: [:pool_name]
      )
    ]
  end
end
