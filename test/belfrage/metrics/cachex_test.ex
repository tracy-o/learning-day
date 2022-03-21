defmodule Belfrage.Metrics.CachexTest do
  use ExUnit.Case, async: true

  test "expose expected metrics from cachex" do
    cache = String.to_atom("cache#{System.unique_integer()}")
    {:ok, _pid} = Cachex.start_link(cache, stats: true)
    {socket, port} = given_udp_port_opened()

    start_reporter(
      metrics: Belfrage.Metrics.Cachex.metrics(),
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
          "cachex.hits:0|g|#cache_name:#{cache},BBCEnvironment:live",
          "cachex.misses:1|g|#cache_name:#{cache},BBCEnvironment:live"
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
          "cachex.hits:1|g|#cache_name:#{cache},BBCEnvironment:live",
          "cachex.misses:1|g|#cache_name:#{cache},BBCEnvironment:live",
          "cachex.writes:1|g|#cache_name:#{cache},BBCEnvironment:live"
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
          "cachex.evictions:1|g|#cache_name:#{cache},BBCEnvironment:live",
          "cachex.expirations:1|g|#cache_name:#{cache},BBCEnvironment:live",
          "cachex.hits:1|g|#cache_name:#{cache},BBCEnvironment:live",
          "cachex.misses:1|g|#cache_name:#{cache},BBCEnvironment:live",
          "cachex.writes:1|g|#cache_name:#{cache},BBCEnvironment:live"
        ],
        "\n"
      )
    )
  end

  # From https://github.com/beam-telemetry/telemetry_metrics_statsd/blob/main/test/telemetry_metrics_statsd_test.exs
  defp given_udp_port_opened() do
    {:ok, socket} = :gen_udp.open(0, [:binary, active: false])
    {:ok, port} = :inet.port(socket)
    {socket, port}
  end

  defp start_reporter(options) do
    {:ok, pid} = TelemetryMetricsStatsd.start_link(options)
    pid
  end

  defp assert_reported(socket, expected_payload) do
    expected_size = byte_size(expected_payload)
    {:ok, {_host, _port, payload}} = :gen_udp.recv(socket, expected_size, 1000)
    assert payload == expected_payload
  end
end
