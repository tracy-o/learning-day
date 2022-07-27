defmodule Belfrage.Metrics.TelemetrySupervisor do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_args) do
    children = [
      {
        TelemetryMetricsStatsd,
        metrics: Belfrage.Metrics.Statsd.metrics(),
        global_tags: [BBCEnvironment: Application.get_env(:belfrage, :production_environment)],
        formatter: :datadog
      },
      {
        TelemetryMetricsPrometheus,
        metrics: Belfrage.Metrics.Prometheus.metrics()
      }
    ]

    Supervisor.init(children, strategy: :one_for_one, max_restarts: 40)
  end
end
