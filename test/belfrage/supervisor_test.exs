defmodule Belfrage.SupervisorTest do
  use ExUnit.Case, async: true

  import Cachex.Spec, only: [{:limit, 1}]
  import Fixtures.Struct
  import Supervisor.Spec, only: [{:worker, 2}]

  @local_cache :cache
  @test_cache :test_cache

  describe "local cache" do
    test "is alive" do
      [{Cachex, pid, :worker, [Cachex]}] =
        Supervisor.which_children(Belfrage.Supervisor)
        |> Enum.filter(fn {cache, _, _, _} -> cache == Cachex end)

      assert is_pid(pid)
      assert Process.alive?(pid)
    end

    test "size limit and reclaim policy configured" do
      conf = Application.get_env(:cachex, :limit)
      limit = limit(size: conf[:size], policy: conf[:policy], reclaim: conf[:reclaim], options: conf[:options])

      assert [limit] ==
               Cachex.inspect(@local_cache, :cache)
               |> elem(1)
               |> Tuple.to_list()
               |> Enum.filter(fn x -> is_tuple(x) and elem(x, 0) == :limit end)
    end

    # least-recently used (LRU) reclaim policy configured
    test "reclaim policy" do
      conf = Application.get_env(:cachex, :limit)
      limit = limit(size: conf[:size], policy: conf[:policy], reclaim: conf[:reclaim], options: conf[:options])

      overflow = 5
      cache_overflow_size = conf[:size] + overflow

      Supervisor.start_link([worker(Cachex, [@test_cache, [limit: limit]])], strategy: :one_for_one)

      Enum.each(1..cache_overflow_size, fn key ->
        struct = struct_with_gzip_resp()

        Cachex.put(
          @test_cache,
          key,
          {struct.response, Belfrage.Timer.now_ms()},
          ttl: struct.private.fallback_ttl
        )

        :timer.sleep(1)
      end)

      # allow time for cache eviction
      Process.sleep(30)
      {:ok, post_reclaim_size} = Cachex.count(@test_cache)

      assert post_reclaim_size < conf[:size]
      assert post_reclaim_size / conf[:size] == conf[:reclaim]

      for evicted_cache_key <- Enum.take(1..cache_overflow_size, cache_overflow_size - post_reclaim_size) do
        assert {:ok, false} = Cachex.exists?(@test_cache, evicted_cache_key)
      end

      for remaining_cache_key <- Enum.take(1..cache_overflow_size, -post_reclaim_size) do
        assert {:ok, true} = Cachex.exists?(@test_cache, remaining_cache_key)
      end
    end
  end
end
