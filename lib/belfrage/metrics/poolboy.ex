defmodule Belfrage.Metrics.Poolboy do
  @moduledoc """
  This module is called by `:telemetry_poller` to periodically collect metrics
  of `:poolboy` pools.
  """

  alias Belfrage.Metrics

  def track_machine_gun_pools() do
    pids = http_client_pool_pids()

    Enum.each(pids, fn pid ->
      {:registered_name, name} = Process.info(pid, :registered_name)
      track(pid, name |> to_string() |> String.split("@") |> hd())
    end)
  end

  def track(pid_or_name, pool_name) do
    {_state_name, available, overflow, monitors} = :poolboy.status(pid_or_name)

    Metrics.measurement(
      [:poolboy, :status],
      %{
        available_workers: available,
        overflow_workers: overflow,
        saturation: pool_saturation(available, overflow, monitors)
      },
      %{
        pool_name: pool_name
      }
    )
  end

  def track_pool_aggregates() do
    pools = [:aws_ex_store_pool, :aws_ex_ray_client_pool] ++ http_client_pool_pids()

    max_saturation =
      pools
      |> Enum.map(&pool_saturation/1)
      |> Enum.max()

    Metrics.measurement([:poolboy, :pools], %{max_saturation: max_saturation}, %{})
  end

  defp http_client_pool_pids() do
    MachineGun.Supervisor
    |> Supervisor.which_children()
    |> Enum.map(fn {:undefined, pid, :worker, [:poolboy]} -> pid end)
  end

  defp pool_saturation(pid_or_name) do
    {_, available, overflow, monitors} = :poolboy.status(pid_or_name)
    pool_saturation(available, overflow, monitors)
  end

  defp pool_saturation(available, overflow, monitors) do
    busy = monitors - overflow
    trunc(busy * 100 / (busy + available))
  end
end
