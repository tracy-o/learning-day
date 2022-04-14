defmodule Belfrage.Metrics.PoolboyTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureLog
  import Belfrage.Test.MetricsHelper

  alias Belfrage.Metrics.Poolboy

  defmodule TestWorker do
    use Agent

    def start_link(_args) do
      Agent.start_link(fn -> nil end)
    end
  end

  defmodule TimingOutPoolClient do
    def status(pid_or_name) do
      exit({:timeout, {:gen_server, :call, [pid_or_name, :status]}})
    end
  end

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
  end

  describe "track/2" do
    test "emits the number of available and overflow workers, and saturation" do
      pool_name = :test_poolboy_pool
      pool_pid = start_pool(size: 2, max_overflow: 1)

      assert_metrics(
        [
          {[:poolboy, :status], %{available_workers: 2, overflow_workers: 0}, %{pool_name: pool_name}}
        ],
        fn -> Poolboy.track(pool_pid, pool_name) end
      )

      use_worker(pool_pid)

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
  end

  describe "track_pool_aggregates/1" do
    test "tracks max saturation of the pools" do
      pool1 = start_pool(size: 2, name: {:local, :test_poolboy_process1})
      pool2 = start_pool(size: 2, name: {:local, :test_poolboy_process2})

      pools = [pool1, pool2]

      assert_metrics(
        [
          {[:poolboy, :pools], %{max_saturation: 0}, %{}}
        ],
        fn -> Poolboy.track_pool_aggregates(pools: pools) end
      )

      use_worker(pool1)

      assert_metrics(
        [
          {[:poolboy, :pools], %{max_saturation: 50}, %{}}
        ],
        fn -> Poolboy.track_pool_aggregates(pools: pools) end
      )

      use_worker(pool2)

      assert_metrics(
        [
          {[:poolboy, :pools], %{max_saturation: 50}, %{}}
        ],
        fn -> Poolboy.track_pool_aggregates(pools: pools) end
      )

      use_worker(pool1)

      assert_metrics(
        [
          {[:poolboy, :pools], %{max_saturation: 100}, %{}}
        ],
        fn -> Poolboy.track_pool_aggregates(pools: pools) end
      )

      use_worker(pool2)

      assert_metrics(
        [
          {[:poolboy, :pools], %{max_saturation: 100}, %{}}
        ],
        fn -> Poolboy.track_pool_aggregates(pools: pools) end
      )
    end

    test "returns the max pool saturation when pool status call times out" do
      assert_metrics(
        [
          {[:poolboy, :pools], %{max_saturation: 100}, %{}}
        ],
        fn -> Poolboy.track_pool_aggregates(pools: [:some_pool], pool_client: TimingOutPoolClient) end
      )
    end

    test "logs expected message when pool status call times out" do
      log = capture_log(fn -> Poolboy.track_pool_aggregates(pools: [:some_pool], pool_client: TimingOutPoolClient) end)

      assert log =~ "\"level\":\"error\""
      assert log =~ "\"metadata\":{}"

      assert log =~
               "\"message\":\"The :poolboy.status/1 call timed out during the saturation calculation of the pool: :some_pool"
    end
  end

  defp start_machine_gun_pool(name, pool_size \\ 1) do
    {:ok, pid} = MachineGun.Supervisor.start(:"#{name}@localhost:1234", "localhost", 1234, pool_size, 0, :lifo, [])
    pid
  end

  defp stop_machine_gun_pool(pid) do
    DynamicSupervisor.terminate_child(MachineGun.Supervisor, pid)
  end

  defp start_pool(opts) do
    name = Keyword.get(opts, :name, {:local, :test_poolboy_process})

    start_supervised!(%{
      id: name,
      start: {:poolboy, :start_link, [Keyword.merge([worker_module: TestWorker], opts), []]}
    })
  end

  defp use_worker(pool_pid) do
    :poolboy.checkout(pool_pid)
  end
end
