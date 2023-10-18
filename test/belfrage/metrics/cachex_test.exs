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
      assert_reported(socket, expected_metric_payload(cache, 0, 0, 10, 0))

      Cachex.put(cache, "key1", "value1", ttl: 50)
      Cachex.get(cache, "key1")
      Belfrage.Metrics.Cachex.track(cache)
      assert_reported(socket, expected_metric_payload(cache, 6, 6, 10, 1))

      Cachex.put(cache, "key2", "other-value2", ttl: 50)
      Belfrage.Metrics.Cachex.track(cache)
      assert_reported(socket, expected_metric_payload(cache, 18, 9, 10, 2))

      # wait for entry to expire and trigger a cleanup
      Process.sleep(100)
      Cachex.purge(cache)
      Belfrage.Metrics.Cachex.track(cache)
      assert_reported(socket, expected_metric_payload(cache, 0, 0, 10, 0))
    end
  end

  defp expected_metric_payload(cache, cache_memory, avg_entry_size, limit, size) do
    Enum.join(
      [
        "cachex.cache_memory:#{cache_memory}|g|#BBCEnvironment:live,cache_name:#{cache}",
        "cachex.average_cache_entry_size:#{avg_entry_size}|g|#BBCEnvironment:live,cache_name:#{cache}",
        "cachex.limit:#{limit}|g|#BBCEnvironment:live,cache_name:#{cache}",
        "cachex.size:#{size}|g|#BBCEnvironment:live,cache_name:#{cache}"
      ],
      "\n"
    )
  end
end
