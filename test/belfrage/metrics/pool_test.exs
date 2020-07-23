defmodule Belfrage.Metrics.PoolTest do
  use ExUnit.Case
  alias Belfrage.Metrics.Pool

  alias Belfrage.Metrics.PoolTest.TestWorker

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

  describe "all_workers/1" do
    test "when there are no pools, return empty list" do
      assert Pool.all_workers([]) == 0
    end

    test "when there is one pool, returns the number of total workers" do
      supervisor_children = supervisor([new_pool(:a_pool, 10, 0)])

      assert Pool.all_workers(supervisor_children) == 10
    end

    test "when there are multiple pools, returns the the workers of the pool with the most workers" do
      supervisor_children = supervisor([new_pool(:a_pool, 10, 0), new_pool(:b_pool, 5, 0)])

      assert Pool.all_workers(supervisor_children) == 10
    end

    test "when overflow pools are created, total workers increase to reflect additional workers" do
      supervisor_children = supervisor([new_pool(:a_pool, 2, 2)])
      do_work(:a_pool)
      do_work(:a_pool)
      do_work(:a_pool)
      do_work(:a_pool)

      assert Pool.all_workers(supervisor_children) == 4
    end
  end

  describe "active_workers/1" do
    test "when there are no pools, return empty list" do
      assert Pool.active_workers([]) == 0
    end

    test "when there is one pool, return the amount of workers being used" do
      supervisor_children = supervisor([new_pool(:a_pool, 2, 0)])
      do_work(:a_pool)

      assert Pool.active_workers(supervisor_children) == 1
    end

    test "when there a multiple pools, returns the value from the pool with the most active workers" do
      supervisor_children = supervisor([new_pool(:a_pool, 4, 0), new_pool(:b_pool, 5, 0)])
      do_work(:a_pool)
      do_work(:b_pool)
      do_work(:b_pool)

      assert Pool.active_workers(supervisor_children) == 2
    end

    test "when overflow pools are created, active workers increase to reflect additional workers" do
      supervisor_children = supervisor([new_pool(:a_pool, 2, 2)])

      do_work(:a_pool)
      do_work(:a_pool)
      do_work(:a_pool)
      do_work(:a_pool)

      assert Pool.active_workers(supervisor_children) == 4
    end
  end
end
