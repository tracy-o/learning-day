defmodule Belfrage.Cache.StoreTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  import Belfrage.Test.CachingHelper

  alias Belfrage.{Struct, CacheControl}

  setup do
    %{
      struct: %Struct{
        request: %Struct.Request{
          method: "GET",
          request_hash: unique_cache_key()
        },
        response: %Struct.Response{
          http_status: 200,
          body: "<p>Hi there.</p>"
        }
      }
    }
  end

  describe "non-cacheable responses are not written to multi-strategy cache" do
    setup %{struct: struct} do
      expect(Belfrage.Clients.CCPMock, :put, 0, fn _struct -> flunk("Should never be called.") end)

      on_exit(fn ->
        stub_dial(:cache_enabled, "true")
        assert {:ok, :content_not_found} == Belfrage.Cache.Local.fetch(struct)
      end)

      :ok
    end

    test "private response is not written to the cache", %{struct: struct} do
      struct = Struct.add(struct, :response, %{cache_directive: CacheControl.Parser.parse("private, max-age=30")})

      Belfrage.Cache.Store.store(struct)
    end

    test "non-200 responses are not written to the cache", %{struct: struct} do
      struct =
        Struct.add(struct, :response, %{
          http_status: 500,
          cache_directive: CacheControl.Parser.parse("public, max-age=30")
        })

      Belfrage.Cache.Store.store(struct)
    end

    test "POST requests are not written to the cache", %{struct: struct} do
      struct =
        struct
        |> Struct.add(:response, %{
          cache_directive: CacheControl.Parser.parse("public, max-age=30")
        })
        |> Struct.add(:request, %{method: "POST"})

      Belfrage.Cache.Store.store(struct)
    end

    test "public without a max age", %{struct: struct} do
      struct = Struct.add(struct, :response, %{cache_directive: CacheControl.Parser.parse("public")})

      Belfrage.Cache.Store.store(struct)
    end

    test "struct with caching disabled is not written to the cache", %{struct: struct} do
      struct =
        struct
        |> Struct.add(:response, %{
          cache_directive: CacheControl.Parser.parse("public, max-age=30")
        })
        |> Struct.add(:private, %{caching_enabled: false})

      Belfrage.Cache.Store.store(struct)
    end

    test "struct with fallback response from the local cache is not written to the cache", %{struct: struct} do
      struct =
        struct
        |> Struct.add(:response, %{
          cache_directive: CacheControl.Parser.parse("public, max-age=30"),
          fallback: true,
          cache_type: :local
        })

      Belfrage.Cache.Store.store(struct)
    end
  end

  describe "cacheable content is written to multi-strategy cache" do
    setup %{struct: struct} do
      expect(Belfrage.Clients.CCPMock, :put, fn _struct -> :ok end)

      on_exit(fn ->
        stub_dial(:cache_enabled, "true")
        assert {:ok, {:local, :fresh}, %Struct.Response{}} = Belfrage.Cache.Local.fetch(struct)

        :ok
      end)

      :ok
    end

    test "public with a max age", %{struct: struct} do
      struct = Struct.add(struct, :response, %{cache_directive: CacheControl.Parser.parse("public, max-age=30")})
      # Also, note that %{fallback: false, cache_type: nil} are default values in struct.response

      Belfrage.Cache.Store.store(struct)
    end

    test "struct with local cache type and no fallback response", %{struct: struct} do
      struct =
        struct
        |> Struct.add(:response, %{
          cache_directive: CacheControl.Parser.parse("public, max-age=30"),
          fallback: false,
          cache_type: :local
        })

      Belfrage.Cache.Store.store(struct)
    end

    test "struct with distributed cache type and no fallback response", %{struct: struct} do
      struct =
        struct
        |> Struct.add(:response, %{
          cache_directive: CacheControl.Parser.parse("public, max-age=30"),
          fallback: false,
          cache_type: :distributed
        })

      Belfrage.Cache.Store.store(struct)
    end
  end

  describe "cacheable content is written to local cache only, as stale" do
    setup %{struct: struct} do
      expect(Belfrage.Clients.CCPMock, :put, 0, fn _struct -> flunk("Should never be called.") end)

      on_exit(fn ->
        stub_dial(:cache_enabled, "true")
        assert {:ok, {:local, :stale}, %Struct.Response{}} = Belfrage.Cache.Local.fetch(struct)

        :ok
      end)

      struct = Struct.add(struct, :response, %{cache_directive: CacheControl.Parser.parse("public, max-age=30")})
      %{struct: struct}
    end

    test "fallback from the distributed cache", %{struct: struct} do
      struct =
        Struct.add(struct, :response, %{
          fallback: true,
          cache_type: :distributed
        })

      Belfrage.Cache.Store.store(struct)
    end
  end
end
