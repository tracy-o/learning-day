defmodule Belfrage.PoolMetricsTest do
  use ExUnit.Case
  alias Belfrage.PoolMetrics

  alias Belfrage.PoolMetricsTest.TestWorker

  def new_pool(name, size, max_overflow) do
    case :poolboy.start_link([
           {:name, {:local, name}},
           {:worker_module, TestWorker},
           {:size, size},
           {:max_overflow, max_overflow}
         ]) do
      {:ok, pool_pid} -> pool_pid
      {:error, _} -> :error
    end
  end

  def supervisor(pids) do
    Enum.map(pids, fn pid -> {:undefined, pid, :worker, [:poolboy]} end)
  end

  def do_work(pool_name) do
    :poolboy.checkout(pool_name, fn pid -> TestWorker.work(pid) end)
  end

  describe "metrics/1" do
    test "when supervisor returns no children, metrics returns nothing" do
      assert PoolMetrics.metrics([]) == []
    end

    test "when supervisor has a child pool, a map of its name, all_workers and active workers are given" do
      supervisor_children = supervisor([new_pool(:a_pool, 2, 0)])

      assert PoolMetrics.metrics(supervisor_children) == [%{name: :a_pool, all_workers: 2, active_workers: 0}]
    end

    test "when a child pool has 1 active worker, the map has an active worker" do
      supervisor_children = supervisor([new_pool(:a_pool, 2, 0)])
      do_work(:a_pool)

      assert PoolMetrics.metrics(supervisor_children) == [%{name: :a_pool, all_workers: 2, active_workers: 1}]
    end

    test "when there is a pool overflow, all_workers includes overflow workers" do
      supervisor_children = supervisor([new_pool(:a_pool, 2, 2)])
      do_work(:a_pool)
      do_work(:a_pool)
      do_work(:a_pool)
      do_work(:a_pool)

      assert PoolMetrics.metrics(supervisor_children) == [%{name: :a_pool, all_workers: 4, active_workers: 4}]
    end

    test "when multiple pools are being supervised more than one metric map is given" do
      supervisor_children = supervisor([new_pool(:a_pool, 2, 0), new_pool(:b_pool, 1, 1)])

      assert PoolMetrics.metrics(supervisor_children) == [
               %{name: :a_pool, all_workers: 2, active_workers: 0},
               %{name: :b_pool, all_workers: 1, active_workers: 0}
             ]
    end
  end
end
