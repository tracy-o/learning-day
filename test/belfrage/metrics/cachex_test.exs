defmodule Belfrage.Metrics.CachexTest do
  use ExUnit.Case, async: true

  import Belfrage.Test.MetricsHelper

  test "expose expected metrics from cachex" do
    cache = String.to_atom("cache#{System.unique_integer()}")
    {:ok, _pid} = Cachex.start_link(cache, stats: true)
    {socket, port} = given_udp_port_opened()

    start_reporter(
      metrics: Belfrage.Metrics.Statsd.cachex_metrics(),
      formatter: :datadog,
      global_tags: [BBCEnvironment: "live"],
      port: port
    )

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
  end
end
