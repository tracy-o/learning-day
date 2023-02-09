defmodule Belfrage.Cache.MultiStrategyTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  alias Belfrage.Envelope
  alias Belfrage.Cache.MultiStrategy
  alias Belfrage.Behaviours.CacheStrategy

  defmodule FreshStrategy do
    @behaviour CacheStrategy

    def store(%Envelope{}), do: {:ok, true}
    def fetch(%Envelope{}), do: {:ok, {:fresh_strategy, :fresh}, %Envelope.Response{body: "<h1>Hello</h1>"}}
    def metric_identifier(), do: "fresh_response_strategy"
  end

  defmodule StaleStrategy do
    @behaviour CacheStrategy

    def store(%Envelope{}), do: {:ok, true}
    def fetch(%Envelope{}), do: {:ok, {:stale_strategy, :stale}, %Envelope.Response{body: "<h1>Hello</h1>"}}
    def metric_identifier(), do: "stale_response_strategy"
  end

  defmodule NotFoundStrategy do
    @behaviour CacheStrategy

    def store(%Envelope{}), do: {:ok, true}
    def fetch(%Envelope{}), do: {:ok, :content_not_found}
    def metric_identifier(), do: "not_found_strategy"
  end

  describe "correct cache strategies to match the requested freshness and fallback_write_sample" do
    test "when only fresh pages are allowed and fallback_write_sample is greater than 0" do
      envelope = Envelope.add(%Envelope{}, :private, %{fallback_write_sample: 1})

      assert [Belfrage.Cache.Local] == MultiStrategy.valid_caches([:fresh], envelope)
    end

    test "when only fresh pages are allowed and fallback_write_sample is 0" do
      envelope = Envelope.add(%Envelope{}, :private, %{fallback_write_sample: 0})

      assert [Belfrage.Cache.Local] == MultiStrategy.valid_caches([:fresh], envelope)
    end

    test "when fresh and stale pages are allowed and fallback_write_sample is greater than 0 the local and distributed strategies are returned in correct order" do
      envelope = Envelope.add(%Envelope{}, :private, %{fallback_write_sample: 1})

      assert [Belfrage.Cache.Local, Belfrage.Cache.Distributed] ==
               MultiStrategy.valid_caches([:fresh, :stale], envelope)
    end

    test "when fresh and stale pages are allowed and fallback_write_sample is 0 only the local strategy is returned" do
      envelope = Envelope.add(%Envelope{}, :private, %{fallback_write_sample: 0})

      assert [Belfrage.Cache.Local] ==
               MultiStrategy.valid_caches([:fresh, :stale], envelope)
    end
  end

  describe "fetch/3" do
    test "when no strategies are provided :content_not_found is returned" do
      envelope = %Envelope{}
      strategies = []
      accepted_freshness = [:fresh, :stale]

      assert {:ok, :content_not_found} == MultiStrategy.fetch(strategies, envelope, accepted_freshness)
    end

    test "first strategy finds response within accepted freshness, does not call second strategy" do
      envelope = %Envelope{}
      strategies = [FreshStrategy, NotFoundStrategy]
      accepted_freshness = [:fresh]

      assert {:ok, {:fresh_strategy, :fresh}, %Envelope.Response{body: "<h1>Hello</h1>"}} ==
               MultiStrategy.fetch(strategies, envelope, accepted_freshness)
    end

    test "one strategy finds response but NOT within accepted freshness" do
      envelope = %Envelope{}
      strategies = [StaleStrategy]
      accepted_freshness = [:fresh]

      assert {:ok, :content_not_found} ==
               MultiStrategy.fetch(strategies, envelope, accepted_freshness)
    end

    test "when all strategies cannot find a cached page" do
      envelope = %Envelope{}
      strategies = [NotFoundStrategy, NotFoundStrategy]
      accepted_freshness = [:fresh, :stale]

      assert {:ok, :content_not_found} == MultiStrategy.fetch(strategies, envelope, accepted_freshness)
    end

    test "when first strategy does not find any content, and the second stategy finds a cached response" do
      envelope = %Envelope{}
      strategies = [NotFoundStrategy, StaleStrategy]
      accepted_freshness = [:fresh, :stale]

      assert {:ok, {:stale_strategy, :stale}, %Envelope.Response{body: "<h1>Hello</h1>"}} ==
               MultiStrategy.fetch(strategies, envelope, accepted_freshness)
    end
  end

  describe "store/1" do
    test "when ccp_enabled dial is true, distributed cache is used" do
      stub_dial(:ccp_enabled, "true")

      envelope = %Envelope{
        request: %Envelope.Request{request_hash: "multi-strategy-cache-test"},
        response: %Envelope.Response{body: "<p>Hello</p>"}
      }

      Belfrage.Clients.CCPMock
      |> expect(:put, 1, fn ^envelope -> :ok end)

      MultiStrategy.store(envelope)
    end

    test "when ccp_enabled dial is false, distributed cache is not used" do
      stub_dial(:ccp_enabled, "false")

      envelope = %Envelope{
        request: %Envelope.Request{request_hash: "multi-strategy-cache-test"},
        response: %Envelope.Response{body: "<p>Hello</p>"}
      }

      Belfrage.Clients.CCPMock
      |> expect(:put, 0, fn ^envelope -> :ok end)

      MultiStrategy.store(envelope)
    end
  end
end
