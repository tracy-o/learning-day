defmodule Belfrage.Cache.MultiStrategyTest do
  use ExUnit.Case, async: true

  alias Belfrage.Struct
  alias Belfrage.Cache.MultiStrategy
  alias Belfrage.Behaviours.CacheStrategy

  defmodule FreshStrategy do
    @behaviour CacheStrategy

    def store(%Struct{}), do: {:ok, true}
    def fetch(%Struct{}), do: {:ok, :fresh, %Struct.Response{body: "<h1>Hello</h1>"}}
    def metric_identifier(), do: "fresh_response_strategy"
  end

  defmodule StaleStrategy do
    @behaviour CacheStrategy

    def store(%Struct{}), do: {:ok, true}
    def fetch(%Struct{}), do: {:ok, :stale, %Struct.Response{body: "<h1>Hello</h1>"}}
    def metric_identifier(), do: "stale_response_strategy"
  end

  defmodule NotFoundStrategy do
    @behaviour CacheStrategy

    def store(%Struct{}), do: {:ok, true}
    def fetch(%Struct{}), do: {:ok, :content_not_found}
    def metric_identifier(), do: "not_found_strategy"
  end

  describe "correct cache strategies to match the requested freshness" do
    test "when only fresh pages are allowed" do
      assert [Belfrage.Cache.Local] == MultiStrategy.valid_caches_for_freshness([:fresh])
    end

    test "when fresh and stale pages are allowed the local and distributed strategies are returned in correct order" do
      assert [Belfrage.Cache.Local, Belfrage.Cache.Distributed] ==
               MultiStrategy.valid_caches_for_freshness([:fresh, :stale])
    end
  end

  describe "fetch/3" do
    test "when no strategies are provided :content_not_found is returned" do
      struct = %Struct{}
      strategies = []
      accepted_freshness = [:fresh, :stale]

      assert {:ok, :content_not_found} == MultiStrategy.fetch(strategies, struct, accepted_freshness)
    end

    test "first strategy finds response within accepted freshness, does not call second strategy" do
      struct = %Struct{}
      strategies = [FreshStrategy, NotFoundStrategy]
      accepted_freshness = [:fresh]

      assert {:ok, :fresh, %Struct.Response{body: "<h1>Hello</h1>"}} ==
               MultiStrategy.fetch(strategies, struct, accepted_freshness)
    end

    test "one strategy finds response but NOT within accepted freshness" do
      struct = %Struct{}
      strategies = [StaleStrategy]
      accepted_freshness = [:fresh]

      assert {:ok, :content_not_found} ==
               MultiStrategy.fetch(strategies, struct, accepted_freshness)
    end

    test "when all strategies cannot find a cached page" do
      struct = %Struct{}
      strategies = [NotFoundStrategy, NotFoundStrategy]
      accepted_freshness = [:fresh, :stale]

      assert {:ok, :content_not_found} == MultiStrategy.fetch(strategies, struct, accepted_freshness)
    end

    test "when first strategy does not find any content, and the second stategy finds a cached response" do
      struct = %Struct{}
      strategies = [NotFoundStrategy, StaleStrategy]
      accepted_freshness = [:fresh, :stale]

      assert {:ok, :stale, %Struct.Response{body: "<h1>Hello</h1>"}} ==
               MultiStrategy.fetch(strategies, struct, accepted_freshness)
    end
  end
end
