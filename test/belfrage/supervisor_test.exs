defmodule Belfrage.SupervisorTest do
  use ExUnit.Case, async: true

  import Cachex.Spec, only: [{:limit, 1}]
  import Fixtures.Envelope
  alias Belfrage.SupervisorObserver

  @belfrage_local_cache :cache
  @test_cache :test_cache

  setup_all do
    conf = Application.get_env(:cachex, :limit)

    overflow = 5
    overflow_size = conf[:size] + overflow
    limit = limit(size: conf[:size], policy: conf[:policy], reclaim: conf[:reclaim], options: conf[:options])

    {:ok, _pid} = start_test_cache(@test_cache, size: 10, limit: limit)

    Cachex.clear(@test_cache)
    seed_test_cache(1..overflow_size, @test_cache)

    Cachex.purge(@test_cache)
    Process.sleep(30)

    %{conf: conf, overflow_size: overflow_size}
  end

  describe "local cache" do
    test "is alive" do
      [{Cachex, pid, :supervisor, [Cachex]}] =
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

  test "ensure children supervisors are monitored by SupervisorObserver" do
    expected_observed_ids = Enum.sort(Belfrage.Supervisor.get_observed_ids())

    %{monitor_map: m_map, observed_ids: observed_ids} = SupervisorObserver.get_state(SupervisorObserver)
    monitor_ids = for {id, _ref} <- m_map, do: id

    assert expected_observed_ids == Enum.sort(observed_ids)
    assert expected_observed_ids == Enum.sort(monitor_ids)
  end

  # This helper starts a new local cache and links it to
  # the test process. It will terminate when the calling
  # process (test case or test module) ends.
  defp start_test_cache(cache, config) do
    default = %{size: 100, policy: Cachex.Policy.LRW, reclaim: 0.3, options: []}

    %{options: opts, policy: policy, reclaim: reclaim, size: size} = Map.merge(default, config |> Enum.into(%{}))

    limit = {:limit, size, policy, reclaim, opts}
    start_supervised(%{id: cache, start: {Cachex, :start_link, [cache, [limit: limit]]}})
  end

  defp seed_test_cache(test_key_range, cache) do
    envelope = envelope_with_gzip_resp()

    Enum.each(test_key_range, fn key ->
      Cachex.put(
        cache,
        key,
        {envelope.response, Belfrage.Timer.now_ms()},
        ttl: 15_000
      )

      :timer.sleep(1)
    end)
  end
end
