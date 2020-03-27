defmodule Belfrage.Cache.MultiStrategyTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox
  alias Belfrage.Struct
  alias Belfrage.Cache.MultiStrategy

  describe "correct cache strategies to match the requested freshness" do
    test "when only fresh pages are allowed" do
      assert [Belfrage.Cache.Local] == MultiStrategy.valid_caches_for_freshness([:fresh])
    end

    test "when fresh and stale pages are allowed" do
      assert [Belfrage.Cache.Local, Belfrage.Cache.Distributed] ==
               MultiStrategy.valid_caches_for_freshness([:fresh, :stale])
    end
  end

  describe "fetch/3" do
    test "when no strategies are provided" do
      struct = %Struct{}
      strategies = []
      accepted_freshness = [:fresh, :stale]

      assert {:ok, :content_not_found} == MultiStrategy.fetch(strategies, struct, accepted_freshness)
    end

    test "strategy finds response within accepted freshness" do
      struct = %Struct{}
      strategies = [CacheStrategyMock]
      accepted_freshness = [:fresh, :stale]

      CacheStrategyMock
      |> expect(:fetch, fn ^struct ->
        {:ok, :fresh, %Struct.Response{body: "<h1>Hello</h1>"}}
      end)

      assert {:ok, :fresh, %Struct.Response{body: "<h1>Hello</h1>"}} ==
               MultiStrategy.fetch(strategies, struct, accepted_freshness)
    end

    test "one strategy finds response but NOT within accepted freshness" do
      struct = %Struct{}
      strategies = [CacheStrategyMock]
      accepted_freshness = [:fresh]

      CacheStrategyMock
      |> expect(:fetch, fn ^struct ->
        {:ok, :stale, %Struct.Response{body: "<h1>Hello</h1>"}}
      end)

      assert {:ok, :content_not_found} ==
               MultiStrategy.fetch(strategies, struct, accepted_freshness)
    end

    test "when all strategies cannot find a cached page" do
      struct = %Struct{}
      strategies = [CacheStrategyMock, CacheStrategyMock]
      accepted_freshness = [:fresh, :stale]

      CacheStrategyMock
      |> expect(:fetch, 2, fn ^struct ->
        {:ok, :content_not_found}
      end)

      assert {:ok, :content_not_found} == MultiStrategy.fetch(strategies, struct, accepted_freshness)
    end

    test "when the last stategy finds a cached response" do
      struct = %Struct{}
      strategies = [CacheStrategyMock, CacheStrategyTwoMock]
      accepted_freshness = [:fresh, :stale]

      CacheStrategyMock
      |> expect(:fetch, fn ^struct ->
        {:ok, :content_not_found}
      end)

      CacheStrategyTwoMock
      |> expect(:fetch, fn ^struct ->
        {:ok, :stale, %Struct.Response{body: "<h1>Hello</h1>"}}
      end)

      assert {:ok, :stale, %Struct.Response{body: "<h1>Hello</h1>"}} ==
               MultiStrategy.fetch(strategies, struct, accepted_freshness)
    end
  end
end
