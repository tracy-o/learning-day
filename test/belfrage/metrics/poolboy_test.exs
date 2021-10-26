defmodule Belfrage.Metrics.PoolboyTest do
  use ExUnit.Case, async: true
  import Belfrage.Test.MetricsHelper
  import Test.Support.Helper, only: [wait_for: 1]

  alias Belfrage.Metrics.Poolboy

  defmodule TestWorker do
    use Agent

    def start_link(_args) do
      Agent.start_link(fn -> nil end)
    end
  end

  describe "track_machine_gun_pools/0" do
    test "tracks children of MachineGun.Supervisor" do
      pool_name = "test-pool"
      pool_pid = start_machine_gun_pool(pool_name)
      on_exit(fn -> stop_machine_gun_pool(pool_pid) end)

      assert_metric(
        {[:poolboy, :status], %{available_workers: 1, saturation: 0, overflow_workers: 0}, %{pool_name: pool_name}},
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
          {[:poolboy, :status], %{available_workers: 2, saturation: 0, overflow_workers: 0}, %{pool_name: pool_name}}
        ],
        fn -> Poolboy.track(pool_pid, pool_name) end
      )

      use_worker(pool_pid)

      assert_metrics(
        [
          {[:poolboy, :status], %{available_workers: 1, saturation: 50, overflow_workers: 0}, %{pool_name: pool_name}}
        ],
        fn -> Poolboy.track(pool_pid, pool_name) end
      )

      use_worker(pool_pid)

      assert_metrics(
        [
          {[:poolboy, :status], %{available_workers: 0, saturation: 100, overflow_workers: 0}, %{pool_name: pool_name}}
        ],
        fn -> Poolboy.track(pool_pid, pool_name) end
      )

      use_worker(pool_pid)

      assert_metrics(
        [
          {[:poolboy, :status], %{available_workers: 0, saturation: 100, overflow_workers: 1}, %{pool_name: pool_name}}
        ],
        fn -> Poolboy.track(pool_pid, pool_name) end
      )
    end

    test "can find the pool by process name" do
      pool_name = :test_poolboy_pool
      start_pool(size: 1, max_overflow: 1, name: {:local, :test_poolboy_process})

      assert_metrics(
        [
          {[:poolboy, :status], %{available_workers: 1, saturation: 0, overflow_workers: 0}, %{pool_name: pool_name}}
        ],
        fn -> Poolboy.track(:test_poolboy_process, pool_name) end
      )
    end
  end

  describe "track_pool_aggregates/1" do
    test "tracks aggregates of the relevant pools when they are started" do
      http_pool_pid = start_machine_gun_pool("test-http-pool", 4)

      store_monitor_pool_size = Application.get_env(:aws_ex_ray, :store_monitor_pool_size)
      client_pool_size = Application.get_env(:aws_ex_ray, :client_pool_size)
      update_aws_ex_ray_pool_sizes(client_pool_size: 2, store_monitor_pool_size: 2)

      assert_metrics(
        [
          {[:poolboy, :pools], %{max_saturation: 0}, %{}}
        ],
        fn -> Poolboy.track_pool_aggregates() end
      )

      use_worker(http_pool_pid)

      assert_metrics(
        [
          {[:poolboy, :pools], %{max_saturation: 25}, %{}}
        ],
        fn -> Poolboy.track_pool_aggregates() end
      )

      use_worker(:aws_ex_ray_client_pool)

      assert_metrics(
        [
          {[:poolboy, :status], %{available_workers: 1, overflow_workers: 0, saturation: 50},
           %{pool_name: "AwsExRayUDPClient"}}
        ],
        fn -> Poolboy.track(:aws_ex_ray_client_pool, "AwsExRayUDPClient") end
      )

      use_worker(:aws_ex_store_pool)
      use_worker(:aws_ex_store_pool)

      assert_metrics(
        [
          {[:poolboy, :pools], %{max_saturation: 100}, %{}}
        ],
        fn -> Poolboy.track_pool_aggregates() end
      )

      stop_machine_gun_pool(http_pool_pid)

      update_aws_ex_ray_pool_sizes(
        client_pool_size: client_pool_size,
        store_monitor_pool_size: store_monitor_pool_size
      )
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

  defp update_aws_ex_ray_pool_sizes(sizes) do
    Supervisor.stop(AwsExRay.Supervisor)
    Application.put_env(:aws_ex_ray, :client_pool_size, sizes[:client_pool_size])
    Application.put_env(:aws_ex_ray, :store_monitor_pool_size, sizes[:store_monitor_pool_size])

    {:ok, _pid} =
      Supervisor.start_link(
        [
          {AwsExRay.Client, []},
          {AwsExRay.Store.MonitorSupervisor, []}
        ],
        strategy: :one_for_one,
        name: AwsExRay.Supervisor
      )

    wait_for(fn -> all_supervisor_specs_active?(AwsExRay.Supervisor) end)
  end

  defp all_supervisor_specs_active?(supervisor) do
    %{active: active, specs: specs, supervisors: _supervisors, workers: _workers} =
      Supervisor.count_children(supervisor)

    specs > 0 and active == specs
  end
end
