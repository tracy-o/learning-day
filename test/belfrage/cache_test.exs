defmodule Belfrage.BelfrageCacheTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Struct

  @cache_seeded_response %Belfrage.Struct.Response{
    body: :zlib.gzip(~s({"hi": "bonjour"})),
    headers: %{"content-type" => "application/json", "content-encoding" => "gzip"},
    http_status: 200,
    cache_directive: %{cacheability: "public", max_age: 30}
  }

  setup do
    :ets.delete_all_objects(:cache)
    Belfrage.LoopsSupervisor.kill_all()

    Test.Support.Helper.insert_cache_seed(
      id: "fresh-cache-item",
      response: @cache_seeded_response,
      expires_in: :timer.hours(6),
      last_updated: Belfrage.Timer.now_ms()
    )

    Test.Support.Helper.insert_cache_seed(
      id: "stale-cache-item",
      response: @cache_seeded_response,
      expires_in: :timer.hours(6),
      last_updated: Belfrage.Timer.now_ms() - :timer.seconds(31)
    )

    :ok
  end

  describe "a fresh cache" do
    test "serves a cached response" do
      struct = %Struct{
        request: %Struct.Request{
          request_hash: "fresh-cache-item"
        }
      }

      assert %Belfrage.Struct{response: @cache_seeded_response} =
               Belfrage.Cache.add_response_from_cache(struct, [:fresh])
    end

    test "served early from cache sets origin to :belfrage_cache" do
      struct = %Struct{
        private: %Struct.Private{
          loop_id: "ALoop"
        },
        request: %Struct.Request{
          request_hash: "fresh-cache-item"
        }
      }

      assert %Struct{private: %Struct.Private{origin: :belfrage_cache}} =
               Belfrage.Cache.add_response_from_cache(struct, [:fresh])
    end
  end

  describe "a stale cache" do
    test "does not add a stale response when requesting a fresh response" do
      struct = %Struct{
        private: %Struct.Private{
          loop_id: "ALoop"
        },
        request: %Struct.Request{
          request_hash: "stale-cache-item"
        }
      }

      assert %Struct{response: %Struct.Response{http_status: nil}} =
               Belfrage.Cache.add_response_from_cache(struct, [:fresh])
    end

    test "fetches cached stale response when requesting fresh or stale" do
      struct = %Struct{
        private: %Struct.Private{
          loop_id: "ALoop"
        },
        request: %Struct.Request{
          request_hash: "stale-cache-item"
        }
      }

      assert %Struct{response: %Struct.Response{fallback: true, http_status: 200}} =
               Belfrage.Cache.add_response_from_cache(struct, [:fresh, :stale])
    end
  end

  describe "saving to cache" do
    setup do
      %{
        cacheable_struct: %Struct{
          private: %Struct.Private{
            loop_id: "ALoop"
          },
          request: %Struct.Request{
            request_hash: "req-hash",
            method: "GET"
          },
          response: %Struct.Response{
            http_status: 200,
            cache_directive: %{cacheability: "public", max_age: 30}
          }
        }
      }
    end

    test "when response is cacheable it should be saved to the cache", %{cacheable_struct: cacheable_struct} do
      Belfrage.Cache.store_if_successful(cacheable_struct)

      assert {:ok, :fresh, cacheable_struct.response} == Belfrage.Cache.Local.fetch(cacheable_struct)
    end

    test "when response is for a POST request it should not be saved to the cache", %{
      cacheable_struct: cacheable_struct
    } do
      non_cacheable_struct = Struct.add(cacheable_struct, :request, %{method: "POST"})

      Belfrage.Cache.store_if_successful(non_cacheable_struct)

      assert {:ok, :content_not_found} == Belfrage.Cache.Local.fetch(non_cacheable_struct)
    end

    test "when response is not successful it should not be saved to the cache", %{cacheable_struct: cacheable_struct} do
      non_cacheable_struct = Struct.add(cacheable_struct, :response, %{http_status: 500})

      Belfrage.Cache.store_if_successful(non_cacheable_struct)

      assert {:ok, :content_not_found} == Belfrage.Cache.Local.fetch(non_cacheable_struct)
    end

    test "when response is not publicly cacheable it should not be saved to the cache", %{
      cacheable_struct: cacheable_struct
    } do
      non_cacheable_struct =
        Struct.add(cacheable_struct, :response, %{cache_directive: %{cacheability: "private", max_age: 30}})

      Belfrage.Cache.store_if_successful(non_cacheable_struct)

      assert {:ok, :content_not_found} == Belfrage.Cache.Local.fetch(non_cacheable_struct)
    end

    test "when response is public, but max age is 0, it should not be saved to the cache", %{
      cacheable_struct: cacheable_struct
    } do
      non_cacheable_struct =
        Struct.add(cacheable_struct, :response, %{cache_directive: %{cacheability: "public", max_age: 0}})

      Belfrage.Cache.store_if_successful(non_cacheable_struct)

      assert {:ok, :content_not_found} == Belfrage.Cache.Local.fetch(non_cacheable_struct)
    end
  end
end
