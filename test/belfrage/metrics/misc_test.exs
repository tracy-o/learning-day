defmodule Belfrage.Metrics.MiscTest do
  use ExUnit.Case, async: true

  import Belfrage.Test.MetricsHelper

  defmodule LocalStrategy do
    @behaviour Belfrage.Behaviours.CacheStrategy

    def store(%Belfrage.Struct{}), do: {:ok, true}

    def fetch(%Belfrage.Struct{}),
      do: {:ok, {:fresh_strategy, :fresh}, %Belfrage.Struct.Response{body: "<h1>Hello</h1>"}}

    def metric_identifier(), do: "local"
  end

  defmodule LocalNotFoundStrategy do
    @behaviour Belfrage.Behaviours.CacheStrategy

    def store(%Belfrage.Struct{}), do: {:ok, true}
    def fetch(%Belfrage.Struct{}), do: {:ok, :content_not_found}
    def metric_identifier(), do: "local"
  end

  defmodule DistributedStrategy do
    @behaviour Belfrage.Behaviours.CacheStrategy

    def store(%Belfrage.Struct{}), do: {:ok, true}

    def fetch(%Belfrage.Struct{}),
      do: {:ok, {:stale_strategy, :stale}, %Belfrage.Struct.Response{body: "<h1>Hello</h1>"}}

    def metric_identifier(), do: "distributed"
  end

  test "no duplicate metrics" do
    names =
      for metric <- Belfrage.Metrics.Misc.metrics() do
        metric.name
      end

    assert Enum.uniq(names) == names
  end

  test "capture metrics for different strategies and freshness" do
    {socket, port} = given_udp_port_opened()

    start_reporter(
      metrics: Belfrage.Metrics.Misc.metrics(),
      formatter: :datadog,
      global_tags: [BBCEnvironment: "live"],
      port: port
    )

    struct = %Belfrage.Struct{
      private: %Belfrage.Struct.Private{
        route_state_id: "ARouteState"
      }
    }

    accepted_freshness = [:fresh, :stale]

    assert {:ok, {:fresh_strategy, :fresh}, _} =
             Belfrage.Cache.MultiStrategy.fetch([LocalStrategy, DistributedStrategy], struct, accepted_freshness)

    assert_reported(socket, "cache.local.fresh.hit:1|c|#BBCEnvironment:live,route_spec:ARouteState")

    assert {:ok, {:stale_strategy, :stale}, _} =
             Belfrage.Cache.MultiStrategy.fetch([DistributedStrategy], struct, accepted_freshness)

    assert_reported(socket, "cache.distributed.stale.hit:1|c|#BBCEnvironment:live,route_spec:ARouteState")

    assert {:ok, :content_not_found} =
             Belfrage.Cache.MultiStrategy.fetch([LocalNotFoundStrategy], struct, accepted_freshness)

    assert_reported(socket, "cache.local.miss:1|c|#BBCEnvironment:live,route_spec:ARouteState")
  end
end
