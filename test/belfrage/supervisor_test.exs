defmodule Belfrage.SupervisorTest do
  use ExUnit.Case, async: true

  import Cachex.Spec, only: [{:limit, 1}]
  import Fixtures.Struct
  import Supervisor.Spec, only: [{:worker, 2}]

  @belfrage_local_cache :cache
  @test_cache :test_cache

  setup_all do
    conf = Application.get_env(:cachex, :limit)

    overflow = 5
    overflow_size = conf[:size] + overflow
    limit = limit(size: conf[:size], policy: conf[:policy], reclaim: conf[:reclaim], options: conf[:options])

    Supervisor.start_link([worker(Cachex, [@test_cache, [limit: limit]])], strategy: :one_for_one)
    seed_test_cache(1..overflow_size, @test_cache)

    %{conf: conf, overflow_size: overflow_size}
  end

  describe "local cache" do
    test "is alive" do
      [{Cachex, pid, :worker, [Cachex]}] =
        Supervisor.which_children(Belfrage.Supervisor)
        |> Enum.filter(fn {cache, _, _, _} -> cache == Cachex end)

      assert is_pid(pid)
      assert Process.alive?(pid)
    end

    test "size limit and reclaim policy configured", %{conf: conf} do
      limit = limit(size: conf[:size], policy: conf[:policy], reclaim: conf[:reclaim], options: conf[:options])

      assert [limit] ==
               Cachex.inspect(@belfrage_local_cache, :cache)
               |> elem(1)
               |> Tuple.to_list()
               |> Enum.filter(fn x -> is_tuple(x) and elem(x, 0) == :limit end)
    end

    # least-recently used (LRU) reclaim policy configured
    test "reclaim policy: correct amount of cache entries evicted", %{conf: conf} do
      {:ok, post_eviction_size} = Cachex.count(@test_cache)
      assert post_eviction_size / conf[:size] == conf[:reclaim]
    end

    test "reclaim policy: evicted cache entries should not exist in cache", %{overflow_size: overflow_size} do
      {:ok, post_eviction_size} = Cachex.count(@test_cache)

      for evicted_cache_key <- Enum.take(1..overflow_size, overflow_size - post_eviction_size) do
        assert {:ok, false} = Cachex.exists?(@test_cache, evicted_cache_key)
      end
    end

    test "reclaim policy: only latest entries exist in cache after a reclaim", %{overflow_size: overflow_size} do
      {:ok, post_eviction_size} = Cachex.count(@test_cache)

      for remaining_cache_key <- Enum.take(1..overflow_size, -post_eviction_size) do
        assert {:ok, true} = Cachex.exists?(@test_cache, remaining_cache_key)
      end
    end
  end

  defp seed_test_cache(test_key_range, cache) do
    Enum.each(test_key_range, fn key ->
      struct = struct_with_gzip_resp()

      Cachex.put(
        cache,
        key,
        {struct.response, Belfrage.Timer.now_ms()},
        ttl: struct.private.fallback_ttl
      )

      :timer.sleep(1)
    end)

    # allow time for cache eviction
    Process.sleep(20)
  end
end
