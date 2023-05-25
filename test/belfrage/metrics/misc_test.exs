defmodule Belfrage.Metrics.MiscTest do
  use ExUnit.Case, async: true

  import Belfrage.Test.MetricsHelper

  defmodule LocalStrategy do
    @behaviour Belfrage.Behaviours.CacheStrategy

    def store(%Belfrage.Envelope{}), do: {:ok, true}

    def fetch(%Belfrage.Envelope{}),
      do: {:ok, {:fresh_strategy, :fresh}, %Belfrage.Envelope.Response{body: "<h1>Hello</h1>"}}

    def metric_identifier(), do: "local"
  end

  defmodule LocalNotFoundStrategy do
    @behaviour Belfrage.Behaviours.CacheStrategy

    def store(%Belfrage.Envelope{}), do: {:ok, true}
    def fetch(%Belfrage.Envelope{}), do: {:ok, :content_not_found}
    def metric_identifier(), do: "local"
  end

  defmodule DistributedStrategy do
    @behaviour Belfrage.Behaviours.CacheStrategy

    def store(%Belfrage.Envelope{}), do: {:ok, true}

    def fetch(%Belfrage.Envelope{}),
      do: {:ok, {:stale_strategy, :stale}, %Belfrage.Envelope.Response{body: "<h1>Hello</h1>"}}

    def metric_identifier(), do: "distributed"
  end

  test "no duplicate metrics" do
    names =
      for metric <- Belfrage.Metrics.Statsd.misc_metrics() do
        metric.name
      end

    assert Enum.uniq(names) == names
  end

  test "capture metrics for different strategies and freshness" do
    {socket, port} = given_udp_port_opened()

    start_reporter(
      metrics: Belfrage.Metrics.Statsd.misc_metrics(),
      formatter: :datadog,
      global_tags: [BBCEnvironment: "live"],
      port: port
    )

    envelope = %Belfrage.Envelope{
      private: %Belfrage.Envelope.Private{
        route_state_id: {"ARouteState", "Webcore"}
      }
    }

    accepted_freshness = [:fresh, :stale]

    assert {:ok, {:fresh_strategy, :fresh}, _} =
             Belfrage.Cache.MultiStrategy.fetch([LocalStrategy, DistributedStrategy], envelope, accepted_freshness)

    assert_reported(socket, "cache.local.fresh.hit:1|c|#BBCEnvironment:live,route_spec:ARouteState.Webcore")

    assert {:ok, {:stale_strategy, :stale}, _} =
             Belfrage.Cache.MultiStrategy.fetch([DistributedStrategy], envelope, accepted_freshness)

    assert_reported(socket, "cache.distributed.stale.hit:1|c|#BBCEnvironment:live,route_spec:ARouteState.Webcore")

    assert {:ok, :content_not_found} =
             Belfrage.Cache.MultiStrategy.fetch([LocalNotFoundStrategy], envelope, accepted_freshness)

    assert_reported(socket, "cache.local.miss:1|c|#BBCEnvironment:live,route_spec:ARouteState.Webcore")
  end
end
