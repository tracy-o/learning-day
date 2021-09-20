defmodule Belfrage.Metrics.PoolboyTest do
  use ExUnit.Case, async: true
  import Belfrage.Test.MetricsHelper

  alias Belfrage.Metrics.Poolboy

  describe "track_machine_gun_pools/0" do
    test "tracks children of MachineGun.Supervisor" do
      pool_name = "test-pool"
      pool_pid = start_machine_gun_pool(pool_name)
      on_exit(fn -> stop_machine_gun_pool(pool_pid) end)

      assert_metric(
        {[:poolboy, :status], %{available_workers: 1, overflow_workers: 0}, %{pool_name: pool_name}},
        fn -> Poolboy.track_machine_gun_pools() end
      )
    end

    defp start_machine_gun_pool(name) do
      {:ok, pid} = MachineGun.Supervisor.start(:"#{name}@localhost:1234", "localhost", 1234, 1, 0, :lifo, [])
      pid
    end

    defp stop_machine_gun_pool(pid) do
      DynamicSupervisor.terminate_child(MachineGun.Supervisor, pid)
    end
  end

  describe "track/2" do
    defmodule TestWorker do
      use Agent

      def start_link(_args) do
        Agent.start_link(fn -> nil end)
      end
    end

    test "emits the number of available and overflow workers" do
      pool_name = :test_poolboy_pool
      pool_pid = start_pool(size: 1, max_overflow: 1)

      assert_metrics(
        [
          {[:poolboy, :status], %{available_workers: 1, overflow_workers: 0}, %{pool_name: pool_name}}
        ],
        fn -> Poolboy.track(pool_pid, pool_name) end
      )

      use_worker(pool_pid)

      assert_metrics(
        [
          {[:poolboy, :status], %{available_workers: 0, overflow_workers: 0}, %{pool_name: pool_name}}
        ],
        fn -> Poolboy.track(pool_pid, pool_name) end
      )

      use_worker(pool_pid)

      assert_metrics(
        [
          {[:poolboy, :status], %{available_workers: 0, overflow_workers: 1}, %{pool_name: pool_name}}
        ],
        fn -> Poolboy.track(pool_pid, pool_name) end
      )
    end

    test "can find the pool by process name" do
      pool_name = :test_poolboy_pool
      start_pool(size: 1, max_overflow: 1, name: {:local, :test_poolboy_process})

      assert_metrics(
        [
          {[:poolboy, :status], %{available_workers: 1, overflow_workers: 0}, %{pool_name: pool_name}}
        ],
        fn -> Poolboy.track(:test_poolboy_process, pool_name) end
      )
    end

    defp start_pool(opts) do
      start_supervised!(%{
        id: :test_poolboy_pool,
        start: {:poolboy, :start_link, [Keyword.merge([worker_module: TestWorker], opts), []]}
      })
    end

    defp use_worker(pool_pid) do
      :poolboy.checkout(pool_pid)
    end
  end
end
