defmodule Belfrage.Metrics.Poolboy do
  @moduledoc """
  This module is called by `:telemetry_poller` to periodically collect metrics
  of `:poolboy` pools.
  """

  alias Belfrage.Metrics

  def track_machine_gun_pools() do
    pids =
      MachineGun.Supervisor
      |> Supervisor.which_children()
      |> Enum.map(fn {:undefined, pid, :worker, [:poolboy]} -> pid end)

    Enum.each(pids, fn pid ->
      {:registered_name, name} = Process.info(pid, :registered_name)
      track(pid, name |> to_string() |> String.split("@") |> hd())
    end)
  end

  def track(pid_or_name, pool_name) do
    {_state_name, workers, overflow, _monitors} = :poolboy.status(pid_or_name)

    Metrics.measurement([:poolboy, :status], %{available_workers: workers, overflow_workers: overflow}, %{
      pool_name: pool_name
    })
  end
end
