defmodule Belfrage.Metrics.NimblePool do
  alias Belfrage.Metrics

  alias Belfrage.Metrics

  def track_pools(supervisor \\ Finch.PoolSupervisor) do
    Enum.each(nimble_pool_pids(supervisor), &track/1)
  end

  def properties(pid) do
    state = :sys.get_state(pid)
    %{queue: state.queue, lazy: state.lazy, resources: state.resources, host: host(state.state)}
  end

  defp track(pid) do
    properties = properties(pid)

    Metrics.measurement(
      [:nimble_pool, :status],
      %{
        available_workers: properties.lazy + :queue.len(properties.resources),
        # WARNING: This is an O(N) measurement that is unbounded
        # as there is no upper bound on the number of queued requests.
        queued_requests: :queue.len(properties.queue)
      },
      %{
        pool_name: properties.host
      }
    )
  end

  defp nimble_pool_pids(supervisor) do
    supervisor
    |> Supervisor.which_children()
    |> Enum.map(fn {:undefined, pid, :worker, _} -> pid end)
  end

  defp host({{_scheme, host, _port}, _config}), do: host
end
