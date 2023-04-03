defmodule Benchmark.RegistryDynamicSupervisor do
  @moduledoc """
  Performance benchmarking of DynamicSupervisor.start_child/2
  compared to Registry.lookup/2 when a process already exists.

  ### To run this experiment
  ```
  $ mix benchmark registry_dynamic_supervisor
  ```

  """

  def run(_) do
    experiment()
  end

  def setup() do
    # Start the Dynamic Supervisor and Registry
    children = [
      {DynamicSupervisor, strategy: :one_for_one, name: Belfrage.RouteStateSupervisor},
      {Registry, keys: :unique, name: Belfrage.RouteStateRegistry}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: BenchmarkSupervisor)

    # Start a RouteState process
    {:ok, _pid} =
      DynamicSupervisor.start_child(
        Belfrage.RouteStateSupervisor,
        {Belfrage.RouteState, {{"NewsIndex", "MozartNews"}, %{}}}
      )
  end

  def cleanup() do
    Supervisor.stop(BenchmarkSupervisor)
  end

  def experiment(_iterations \\ 1000) do
    setup()

    Benchee.run(
      %{
        "DynamicSupervisor.start_child/2" => fn ->
          {:error, {:already_started, _pid}} =
            DynamicSupervisor.start_child(
              Belfrage.RouteStateSupervisor,
              {Belfrage.RouteState, {{"NewsIndex", "MozartNews"}, %{}}}
            )
        end,
        "Registry.lookup/2" => fn ->
          [{_pid, _}] = Registry.lookup(Belfrage.RouteStateRegistry, {Belfrage.RouteState, {"NewsIndex", "MozartNews"}})
        end
      },
      time: 10,
      memory_time: 2
    )

    cleanup()
  end
end
