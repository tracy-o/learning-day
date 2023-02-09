defmodule Belfrage.Cache.StoreTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  import Belfrage.Test.CachingHelper

  alias Belfrage.{Envelope, CacheControl}

  setup do
    %{
      envelope: %Envelope{
        request: %Envelope.Request{
          method: "GET",
          request_hash: unique_cache_key()
        },
        response: %Envelope.Response{
          http_status: 200,
          body: "<p>Hi there.</p>"
        }
      }
    }
  end

  describe "non-cacheable responses are not written to multi-strategy cache" do
    setup %{envelope: envelope} do
      expect(Belfrage.Clients.CCPMock, :put, 0, fn _envelope -> flunk("Should never be called.") end)

      on_exit(fn ->
        stub_dial(:cache_enabled, "true")
        assert {:ok, :content_not_found} == Belfrage.Cache.Local.fetch(envelope)
      end)

      :ok
    end

    test "private response is not written to the cache", %{envelope: envelope} do
      envelope = Envelope.add(envelope, :response, %{cache_directive: CacheControl.Parser.parse("private, max-age=30")})

      Belfrage.Cache.Store.store(envelope)
    end

    test "non-200 responses are not written to the cache", %{envelope: envelope} do
      envelope =
        Envelope.add(envelope, :response, %{
          http_status: 500,
          cache_directive: CacheControl.Parser.parse("public, max-age=30")
        })

      Belfrage.Cache.Store.store(envelope)
    end

    test "POST requests are not written to the cache", %{envelope: envelope} do
      envelope =
        envelope
        |> Envelope.add(:response, %{
          cache_directive: CacheControl.Parser.parse("public, max-age=30")
        })
        |> Envelope.add(:request, %{method: "POST"})

      Belfrage.Cache.Store.store(envelope)
    end

    test "public without a max age", %{envelope: envelope} do
      envelope = Envelope.add(envelope, :response, %{cache_directive: CacheControl.Parser.parse("public")})

      Belfrage.Cache.Store.store(envelope)
    end

    test "envelope with caching disabled is not written to the cache", %{envelope: envelope} do
      envelope =
        envelope
        |> Envelope.add(:response, %{
          cache_directive: CacheControl.Parser.parse("public, max-age=30")
        })
        |> Envelope.add(:private, %{caching_enabled: false})

      Belfrage.Cache.Store.store(envelope)
    end

    test "envelope with fallback response from the local cache is not written to the cache", %{envelope: envelope} do
      envelope =
        envelope
        |> Envelope.add(:response, %{
          cache_directive: CacheControl.Parser.parse("public, max-age=30"),
          fallback: true,
          cache_type: :local
        })

      Belfrage.Cache.Store.store(envelope)
    end
  end

  describe "cacheable content is written to multi-strategy cache" do
    setup %{envelope: envelope} do
      expect(Belfrage.Clients.CCPMock, :put, fn _envelope -> :ok end)

      on_exit(fn ->
        stub_dial(:cache_enabled, "true")
        assert {:ok, {:local, :fresh}, %Envelope.Response{}} = Belfrage.Cache.Local.fetch(envelope)

        :ok
      end)

      :ok
    end

    test "public with a max age", %{envelope: envelope} do
      envelope = Envelope.add(envelope, :response, %{cache_directive: CacheControl.Parser.parse("public, max-age=30")})
      # Also, note that %{fallback: false, cache_type: nil} are default values in envelope.response

      Belfrage.Cache.Store.store(envelope)
    end

    test "envelope with local cache type and no fallback response", %{envelope: envelope} do
      envelope =
        envelope
        |> Envelope.add(:response, %{
          cache_directive: CacheControl.Parser.parse("public, max-age=30"),
          fallback: false,
          cache_type: :local
        })

      Belfrage.Cache.Store.store(envelope)
    end

    test "envelope with distributed cache type and no fallback response", %{envelope: envelope} do
      envelope =
        envelope
        |> Envelope.add(:response, %{
          cache_directive: CacheControl.Parser.parse("public, max-age=30"),
          fallback: false,
          cache_type: :distributed
        })

      Belfrage.Cache.Store.store(envelope)
    end
  end

  describe "cacheable content is written to local cache only, as stale" do
    setup %{envelope: envelope} do
      expect(Belfrage.Clients.CCPMock, :put, 0, fn _envelope -> flunk("Should never be called.") end)

      on_exit(fn ->
        stub_dial(:cache_enabled, "true")
        assert {:ok, {:local, :stale}, %Envelope.Response{}} = Belfrage.Cache.Local.fetch(envelope)

        :ok
      end)

      envelope = Envelope.add(envelope, :response, %{cache_directive: CacheControl.Parser.parse("public, max-age=30")})
      %{envelope: envelope}
    end

    test "fallback from the distributed cache", %{envelope: envelope} do
      envelope =
        Envelope.add(envelope, :response, %{
          fallback: true,
          cache_type: :distributed
        })

      Belfrage.Cache.Store.store(envelope)
    end
  end
end
