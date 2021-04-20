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

  describe "get_workers/1" do
    test "when there are no pools, return empty list" do
      assert Pool.get_workers([]) == 0
    end

    test "when there is one pool, returns the total number of workers available" do
      supervisor_children = supervisor([new_pool(:a_pool, 10, 0)])

      assert Pool.get_workers(supervisor_children) == 10

      do_work(:a_pool)

      assert Pool.get_workers(supervisor_children) == 9
    end

    test "when there are multiple pools, returns the the workers of the pool with the most available workers" do
      supervisor_children = supervisor([new_pool(:a_pool, 12, 0), new_pool(:b_pool, 5, 0), new_pool(:c_pool, 7, 0)])

      assert Pool.get_workers(supervisor_children) == 12
    end

    test "when overflow pools are created, workers is 0 to reflect all are being used" do
      supervisor_children = supervisor([new_pool(:a_pool, 2, 2)])
      do_work(:a_pool)
      do_work(:a_pool)
      do_work(:a_pool)
      do_work(:a_pool)

      assert Pool.get_workers(supervisor_children) == 0
    end
  end

  describe "get_overflow/1" do
    test "when there are no pools, return empty list" do
      assert Pool.get_overflow([]) == 0
    end

    test "when there is one pool, return the amount of overflow being used" do
      supervisor_children = supervisor([new_pool(:a_pool, 2, 2)])
      do_work(:a_pool)
      do_work(:a_pool)

      assert Pool.get_overflow(supervisor_children) == 0

      do_work(:a_pool)

      assert Pool.get_overflow(supervisor_children) == 1
    end

    test "when there a multiple pools, returns the value from the pool with the most overflow being used" do
      supervisor_children = supervisor([new_pool(:a_pool, 0, 1), new_pool(:b_pool, 0, 2), new_pool(:c_pool, 0, 3)])

      do_work(:b_pool)
      do_work(:b_pool)

      do_work(:c_pool)
      do_work(:c_pool)
      do_work(:c_pool)

      assert Pool.get_overflow(supervisor_children) == 3
    end
  end
end
