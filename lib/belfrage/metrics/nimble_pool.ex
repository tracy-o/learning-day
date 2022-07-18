defmodule Belfrage.Metrics.NimblePool do
  alias Belfrage.Metrics

  import Telemetry.Metrics
  alias Belfrage.Metrics

  def metrics() do
    [
      last_value("nimble_pool.available_workers.count",
        measurement: :available_workers,
        event_name: "belfrage.nimble_pool.status",
        tags: [:pool_name, :BBCEnvironment]
      ),
      last_value("nimble_pool.queued_requests.count",
        measurement: :queued_requests,
        event_name: "belfrage.nimble_pool.status",
        tags: [:pool_name, :BBCEnvironment]
      )
    ]
  end

  def track_pools(supervisor \\ Finch.PoolSupervisor) do
    Enum.each(nimble_pool_pids(supervisor), &track/1)
  end

  defp track(pid) do
    %{queue: queue, lazy: lazy, resources: resources, state: {pool, %{}}} = :sys.get_state(pid)

    Metrics.measurement(
      [:nimble_pool, :status],
      %{
        available_workers: lazy + :queue.len(resources),
        # WARNING: This is an O(N) measurement that is unbounded
        # as there is no upper bound on the number of queued requests.
        queued_requests: :queue.len(queue)
      },
      %{
        pool_name: pool_name(pool)
      }
    )
  end

  defp nimble_pool_pids(supervisor) do
    supervisor
    |> Supervisor.which_children()
    |> Enum.map(fn {:undefined, pid, :worker, _} -> pid end)
  end

  defp pool_name({_scheme, host, _port}), do: host
end
