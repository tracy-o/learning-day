defmodule Belfrage.Cache.StoreTest do
  use ExUnit.Case
  import Belfrage.Test.CachingHelper

  alias Belfrage.{Struct, CacheControl}

  use Test.Support.Helper, :mox

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
  end

  describe "cacheable content is written to multi-strategy cache" do
    setup %{struct: struct} do
      expect(Belfrage.Clients.CCPMock, :put, fn _struct -> :ok end)

      on_exit(fn ->
        assert {:ok, :fresh, %Struct.Response{}} = Belfrage.Cache.Local.fetch(struct)

        :ok
      end)

      :ok
    end

    test "public with a max age", %{struct: struct} do
      struct = Struct.add(struct, :response, %{cache_directive: CacheControl.Parser.parse("public, max-age=30")})

      Belfrage.Cache.Store.store(struct)
    end
  end
end
