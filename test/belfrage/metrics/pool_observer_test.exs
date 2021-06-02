defmodule Belfrage.Metrics.PoolObserverTest do
  use ExUnit.Case
  alias Belfrage.Metrics.PoolObserver
  alias Belfrage.Metrics.PoolObserverTest.TestWorker

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

  def do_work(pool_name) do
    :poolboy.checkout(pool_name, fn pid -> TestWorker.work(pid) end)
  end

  describe "get_data/1" do
    test "when there are no pools, returns 0 for both elements in list" do
      assert PoolObserver.get_data([]) == %{number_of_workers: 0, number_of_overflow_workers: 0}
    end

    test "when there is one pool, returns the total number of workers available" do
      pids = [new_pool(:a_pool, 10, 0)]
      assert PoolObserver.get_data(pids) == %{number_of_workers: 10, number_of_overflow_workers: 0}

      do_work(:a_pool)

      assert PoolObserver.get_data(pids) == %{number_of_workers: 9, number_of_overflow_workers: 0}
    end

    test "when there are multiple pools, returns the workers of the pool with the least available workers" do
      pids = [new_pool(:a_pool, 12, 0), new_pool(:b_pool, 5, 0), new_pool(:c_pool, 7, 0)]

      assert PoolObserver.get_data(pids) == %{number_of_workers: 5, number_of_overflow_workers: 0}
    end

    test "when overflow pools are created, workers is 0 to reflect all are being used" do
      pids = [new_pool(:a_pool, 2, 2)]

      do_work(:a_pool)
      do_work(:a_pool)
      do_work(:a_pool)
      do_work(:a_pool)

      assert PoolObserver.get_data(pids) == %{number_of_workers: 0, number_of_overflow_workers: 2}
    end

    test "when there is one pool, return the amount of overflow being used" do
      pids = [new_pool(:a_pool, 2, 2)]

      do_work(:a_pool)
      do_work(:a_pool)

      assert PoolObserver.get_data(pids) == %{number_of_workers: 0, number_of_overflow_workers: 0}

      do_work(:a_pool)

      assert PoolObserver.get_data(pids) == %{number_of_workers: 0, number_of_overflow_workers: 1}
    end

    test "when there a multiple pools, returns the value from the pool with the most overflow being used" do
      pids = [new_pool(:a_pool, 0, 1), new_pool(:b_pool, 0, 2), new_pool(:c_pool, 0, 3)]

      do_work(:b_pool)
      do_work(:b_pool)

      do_work(:c_pool)
      do_work(:c_pool)
      do_work(:c_pool)

      assert PoolObserver.get_data(pids) == %{number_of_workers: 0, number_of_overflow_workers: 3}
    end
  end
end
