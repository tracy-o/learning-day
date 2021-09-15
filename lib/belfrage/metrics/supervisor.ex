defmodule Belfrage.Metrics.Supervisor do
  use Supervisor, restart: :temporary

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(args) do
    Supervisor.init(children(args), strategy: :one_for_one, max_restarts: 10)
  end

  defp children(env: :test) do
    [
      Belfrage.Metrics.MailboxMonitor
    ]
  end

  defp children(env: env) when env in [:routes_test, :smoke_test] do
    []
  end

  defp children(_env) do
    [
      Belfrage.Metrics.MailboxMonitor,
      Belfrage.Metrics.TelemetrySupervisor,
      Belfrage.Metrics.LatencyMonitor,
      {:telemetry_poller,
       [
         measurements: [
           {Belfrage.Metrics.Poolboy, :track_machine_gun_pools, []}
         ],
         period: :timer.seconds(5),
         name: :belfrage_telemetry_poller
       ]}
    ]
  end
end
