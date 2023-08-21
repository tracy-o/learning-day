defmodule Belfrage.Metrics.CachexTest do
  use ExUnit.Case, async: true

  import Belfrage.Test.MetricsHelper

  describe "expose" do
    setup do
      cache = String.to_atom("cache#{System.unique_integer()}")
      limit_config = {:limit, 10, Cachex.Policy.LRW, 0.1, []}
      {:ok, _pid} = Cachex.start_link(cache, limit: limit_config, stats: true)
      {socket, port} = given_udp_port_opened()

      start_reporter(
        metrics: Belfrage.Metrics.Statsd.cachex_metrics(),
        formatter: :datadog,
        global_tags: [BBCEnvironment: "live"],
        port: port
      )

      %{cache: cache, socket: socket}
    end

    test "stats measurement metrics from cachex", %{cache: cache, socket: socket} do
      Cachex.get(cache, "key1")

      Belfrage.Metrics.Cachex.track(cache)

      assert_reported(
        socket,
        Enum.join(
          [
            "cachex.evictions:0|g|#BBCEnvironment:live,cache_name:#{cache}",
            "cachex.expirations:0|g|#BBCEnvironment:live,cache_name:#{cache}",
            "cachex.hits:0|g|#BBCEnvironment:live,cache_name:#{cache}",
            "cachex.misses:1|g|#BBCEnvironment:live,cache_name:#{cache}",
            "cachex.updates:0|g|#BBCEnvironment:live,cache_name:#{cache}",
            "cachex.writes:0|g|#BBCEnvironment:live,cache_name:#{cache}"
          ],
          "\n"
        )
      )

      assert_reported(
        socket,
        "cachex.size:0|g|#BBCEnvironment:live,cache_name:#{cache}"
      )

      Cachex.put(cache, "key1", "value1", ttl: 50)
      Cachex.get(cache, "key1")

      Belfrage.Metrics.Cachex.track(cache)

      assert_reported(
        socket,
        Enum.join(
          [
            "cachex.evictions:0|g|#BBCEnvironment:live,cache_name:#{cache}",
            "cachex.expirations:0|g|#BBCEnvironment:live,cache_name:#{cache}",
            "cachex.hits:1|g|#BBCEnvironment:live,cache_name:#{cache}",
            "cachex.misses:1|g|#BBCEnvironment:live,cache_name:#{cache}",
            "cachex.updates:0|g|#BBCEnvironment:live,cache_name:#{cache}",
            "cachex.writes:1|g|#BBCEnvironment:live,cache_name:#{cache}"
          ],
          "\n"
        )
      )

      assert_reported(
        socket,
        "cachex.size:1|g|#BBCEnvironment:live,cache_name:#{cache}"
      )

      # wait for entry to expire and trigger a cleanup
      Process.sleep(100)
      Cachex.purge(cache)

      Belfrage.Metrics.Cachex.track(cache)

      assert_reported(
        socket,
        Enum.join(
          [
            "cachex.evictions:1|g|#BBCEnvironment:live,cache_name:#{cache}",
            "cachex.expirations:1|g|#BBCEnvironment:live,cache_name:#{cache}",
            "cachex.hits:1|g|#BBCEnvironment:live,cache_name:#{cache}",
            "cachex.misses:1|g|#BBCEnvironment:live,cache_name:#{cache}",
            "cachex.updates:0|g|#BBCEnvironment:live,cache_name:#{cache}",
            "cachex.writes:1|g|#BBCEnvironment:live,cache_name:#{cache}"
          ],
          "\n"
        )
      )

      assert_reported(
        socket,
        "cachex.size:0|g|#BBCEnvironment:live,cache_name:#{cache}"
      )
    end

    test "cache memory metrics from cachex", %{cache: cache, socket: socket} do
      Cachex.put(cache, "key1", "value1", ttl: 50)
      Belfrage.Metrics.Cachex.track_cache_memory(cache)

      assert_reported(
        socket,
        Enum.join(
          [
            "cachex.cache_memory:6|g|#BBCEnvironment:live,cache_name:#{cache}",
            "cachex.average_cache_entry_size:6|g|#BBCEnvironment:live,cache_name:#{cache}",
            "cachex.limit:10|g|#BBCEnvironment:live,cache_name:#{cache}"
          ],
          "\n"
        )
      )

      Cachex.put(cache, "key2", "other-value2", ttl: 50)
      Belfrage.Metrics.Cachex.track_cache_memory(cache)

      assert_reported(
        socket,
        Enum.join(
          [
            "cachex.cache_memory:18|g|#BBCEnvironment:live,cache_name:#{cache}",
            "cachex.average_cache_entry_size:9|g|#BBCEnvironment:live,cache_name:#{cache}",
            "cachex.limit:10|g|#BBCEnvironment:live,cache_name:#{cache}"
          ],
          "\n"
        )
      )
    end
  end
end
