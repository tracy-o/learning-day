defmodule Belfrage.Metrics.Supervisor do
  use Supervisor, restart: :temporary

  alias Belfrage.Metrics

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(args) do

    Supervisor.init(children(args), strategy: :one_for_one, max_restarts: 10)
  end

  defp children(env: :test) do
    [
      Metrics.ProcessMessageQueueLength.Supervisor
    ]
  end

  defp children(env: env) when env in [:smoke_test] do
    []
  end

  defp children(_env) do
    [
      Metrics.TelemetrySupervisor,
      Metrics.LatencyMonitor,
      {:telemetry_poller,
       [
         measurements: [
           {Metrics.Poolboy, :track_machine_gun_pools, []},
           {Metrics.Poolboy, :track, [:aws_ex_store_pool, "AwsExRayProcessMonitor"]},
           {Metrics.Poolboy, :track, [:aws_ex_ray_client_pool, "AwsExRayUDPClient"]},
           {Metrics.Poolboy, :track_pool_aggregates, []}
         ],
         period: :timer.seconds(5),
         name: :belfrage_telemetry_poller
       ]},
      Metrics.ProcessMessageQueueLength.Supervisor
    ]
  end
end
