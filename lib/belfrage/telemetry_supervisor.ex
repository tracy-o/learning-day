defmodule Belfrage.TelemetrySupervisor do
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

    Supervisor.init(children, strategy: :one_for_one)
  end

  defp telemetry_metrics do
    [
      last_value("vm.memory.total", unit: {:byte, :kilobyte}),
      last_value("vm.system_counts.process_count"),
      last_value("vm.system_counts.atom_count"),
      last_value("vm.system_counts.port_count"),
      last_value("vm.total_run_queue_lengths.total"),
      last_value("vm.total_run_queue_lengths.cpu"),
      last_value("vm.total_run_queue_lengths.io")
    ]
  end
end
