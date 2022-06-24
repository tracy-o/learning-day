defmodule Belfrage.Cache.MultiStrategyTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  alias Belfrage.Struct
  alias Belfrage.Cache.MultiStrategy
  alias Belfrage.Behaviours.CacheStrategy

  defmodule FreshStrategy do
    @behaviour CacheStrategy

    def store(%Struct{}), do: {:ok, true}
    def fetch(%Struct{}), do: {:ok, {:fresh_strategy, :fresh}, %Struct.Response{body: "<h1>Hello</h1>"}}
    def metric_identifier(), do: "fresh_response_strategy"
  end

  defmodule StaleStrategy do
    @behaviour CacheStrategy

    def store(%Struct{}), do: {:ok, true}
    def fetch(%Struct{}), do: {:ok, {:stale_strategy, :stale}, %Struct.Response{body: "<h1>Hello</h1>"}}
    def metric_identifier(), do: "stale_response_strategy"
  end

  defmodule NotFoundStrategy do
    @behaviour CacheStrategy

    def store(%Struct{}), do: {:ok, true}
    def fetch(%Struct{}), do: {:ok, :content_not_found}
    def metric_identifier(), do: "not_found_strategy"
  end

  describe "correct cache strategies to match the requested freshness and fallback_write_sample" do
    test "when only fresh pages are allowed and fallback_write_sample is greater than 0" do
      struct = Struct.add(%Struct{}, :private, %{fallback_write_sample: 1})

      assert [Belfrage.Cache.Local] == MultiStrategy.valid_caches([:fresh], struct)
    end

    test "when only fresh pages are allowed and fallback_write_sample is 0" do
      struct = Struct.add(%Struct{}, :private, %{fallback_write_sample: 0})

      assert [Belfrage.Cache.Local] == MultiStrategy.valid_caches([:fresh], struct)
    end

    test "when fresh and stale pages are allowed and fallback_write_sample is greater than 0 the local and distributed strategies are returned in correct order" do
      struct = Struct.add(%Struct{}, :private, %{fallback_write_sample: 1})

      assert [Belfrage.Cache.Local, Belfrage.Cache.Distributed] ==
               MultiStrategy.valid_caches([:fresh, :stale], struct)
    end

    test "when fresh and stale pages are allowed and fallback_write_sample is 0 only the local strategy is returned" do
      struct = Struct.add(%Struct{}, :private, %{fallback_write_sample: 0})

      assert [Belfrage.Cache.Local] ==
               MultiStrategy.valid_caches([:fresh, :stale], struct)
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

      assert {:ok, {:fresh_strategy, :fresh}, %Struct.Response{body: "<h1>Hello</h1>"}} ==
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

      assert {:ok, {:stale_strategy, :stale}, %Struct.Response{body: "<h1>Hello</h1>"}} ==
               MultiStrategy.fetch(strategies, struct, accepted_freshness)
    end
  end

  describe "store/1" do
    test "when ccp_enabled dial is true, distributed cache is used" do
      stub_dial(:ccp_enabled, "true")

      struct = %Struct{
        request: %Struct.Request{request_hash: "multi-strategy-cache-test"},
        response: %Struct.Response{body: "<p>Hello</p>"}
      }

      Belfrage.Clients.CCPMock
      |> expect(:put, 1, fn ^struct -> :ok end)

      MultiStrategy.store(struct)
    end

    test "when ccp_enabled dial is true, distributed cache is not used" do
      stub_dial(:ccp_enabled, "false")

      struct = %Struct{
        request: %Struct.Request{request_hash: "multi-strategy-cache-test"},
        response: %Struct.Response{body: "<p>Hello</p>"}
      }

      Belfrage.Clients.CCPMock
      |> expect(:put, 0, fn ^struct -> :ok end)

      MultiStrategy.store(struct)
    end
  end
end
