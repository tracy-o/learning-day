defmodule Belfrage.Metrics.Poolboy do
  @moduledoc """
  This module is called by `:telemetry_poller` to periodically collect metrics
  of `:poolboy` pools.
  """

  alias Belfrage.Metrics
  alias Belfrage.Event

  @max_pool_saturation 100

  def track_machine_gun_pools() do
    pids = http_client_pool_pids()

    Enum.each(pids, fn pid ->
      {:registered_name, name} = Process.info(pid, :registered_name)
      track(pid, name |> to_string() |> String.split("@") |> hd())
    end)
  end

  def track(pid_or_name, pool_name) do
    {_state_name, available, overflow, _monitors} = :poolboy.status(pid_or_name)

    Metrics.measurement(
      [:poolboy, :status],
      %{
        available_workers: available,
        overflow_workers: overflow
      },
      %{
        pool_name: pool_name
      }
    )
  end

  def track_pool_aggregates(opts \\ []) do
    %{pool_client: pool_client, pools: pools} = Enum.into(opts, %{pool_client: :poolboy, pools: list_pools()})

    max_saturation =
      pools
      |> Enum.map(&pool_saturation(&1, pool_client))
      |> Enum.max()

    Metrics.measurement([:poolboy, :pools], %{max_saturation: max_saturation}, %{})
  end

  def list_pools() do
    [:aws_ex_store_pool, :aws_ex_ray_client_pool] ++ http_client_pool_pids()
  end

  defp http_client_pool_pids() do
    MachineGun.Supervisor
    |> Supervisor.which_children()
    |> Enum.map(fn {:undefined, pid, :worker, [:poolboy]} -> pid end)
  end

  defp pool_saturation(available, overflow, monitors) do
    busy = monitors - overflow
    trunc(busy * @max_pool_saturation / (busy + available))
  end

  defp pool_saturation(pid_or_name, pool_client) do
    {_, available, overflow, monitors} = pool_client.status(pid_or_name)
    pool_saturation(available, overflow, monitors)
  catch
    :exit, {:timeout, {:gen_server, :call, [^pid_or_name, :status]}} ->
      Event.record(:log, :error, %{
        msg:
          "The :poolboy.status/1 call timed out during the saturation calculation of the pool: #{inspect(pid_or_name)}"
      })

      @max_pool_saturation
  end
end
