defmodule Belfrage.BelfrageCacheTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox
  import Belfrage.Test.CachingHelper

  alias Belfrage.Struct

  @cache_seeded_response %Belfrage.Struct.Response{
    body: :zlib.gzip(~s({"hi": "bonjour"})),
    headers: %{"content-type" => "application/json", "content-encoding" => "gzip"},
    http_status: 200,
    cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 30},
    cache_last_updated: Belfrage.Timer.now_ms()
  }

  setup do
    put_into_cache(cache_key("fresh"), @cache_seeded_response)

    stale_response = %{
      @cache_seeded_response
      | cache_last_updated: Belfrage.Timer.now_ms() - :timer.seconds(31)
    }

    put_into_cache(cache_key("stale"), stale_response)

    %{stale_response: stale_response}
  end

  describe "a fresh cache" do
    test "serves a cached response" do
      struct = %Struct{
        request: %Struct.Request{
          request_hash: cache_key("fresh")
        }
      }

      assert %Belfrage.Struct{response: @cache_seeded_response} = Belfrage.Cache.fetch(struct, [:fresh])
    end

    test "served early from cache sets origin to :belfrage_cache" do
      struct = %Struct{
        private: %Struct.Private{
          route_state_id: "ARouteState"
        },
        request: %Struct.Request{
          request_hash: cache_key("fresh")
        }
      }

      assert %Struct{private: %Struct.Private{origin: :belfrage_cache}} = Belfrage.Cache.fetch(struct, [:fresh])
    end
  end

  describe "a stale cache" do
    test "does not add a stale response when requesting a fresh response" do
      struct = %Struct{
        private: %Struct.Private{
          route_state_id: "ARouteState"
        },
        request: %Struct.Request{
          request_hash: cache_key("stale")
        }
      }

      assert %Struct{response: %Struct.Response{http_status: nil}} = Belfrage.Cache.fetch(struct, [:fresh])
    end

    test "fetches cached stale response when requesting fresh or stale content and the local cache returns the content" do
      struct = %Struct{
        private: %Struct.Private{
          route_state_id: "ARouteState"
        },
        request: %Struct.Request{
          request_hash: cache_key("stale")
        }
      }

      assert %Struct{response: %Struct.Response{cache_type: :local, fallback: true, http_status: 200}} =
               Belfrage.Cache.fetch(struct, [:fresh, :stale])
    end

    test "fetches cached stale response when requesting stale content and the distributed cache returns the content", %{
      stale_response: stale_response
    } do
      # Make sure the local cache does not contain the content
      clear_cache()

      # Ensure that distributed cache client returns the content
      expect(Belfrage.Clients.CCPMock, :fetch, fn _struct -> {:ok, stale_response} end)

      struct = %Struct{
        private: %Struct.Private{
          route_state_id: "ARouteState"
        },
        request: %Struct.Request{
          request_hash: cache_key("stale")
        }
      }

      assert %Struct{response: %Struct.Response{cache_type: :distributed, fallback: true, http_status: 200}} =
               Belfrage.Cache.fetch(struct, [:stale])
    end
  end

  describe "saving to cache" do
    setup do
      %{
        cacheable_struct: %Struct{
          private: %Struct.Private{
            route_state_id: "ARouteState"
          },
          request: %Struct.Request{
            request_hash: unique_cache_key(),
            method: "GET"
          },
          response: %Struct.Response{
            http_status: 200,
            cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 30}
          }
        }
      }
    end

    test "when response is cacheable it should be saved to the cache", %{cacheable_struct: cacheable_struct} do
      Belfrage.Cache.store(cacheable_struct)

      {status, {_, state}, response} = Belfrage.Cache.Local.fetch(cacheable_struct)
      assert :ok == status
      assert :fresh == state

      assert response.cache_directive == cacheable_struct.response.cache_directive
      assert response.http_status == cacheable_struct.response.http_status

      refute response.cache_last_updated == nil
    end

    test "when max-age is nil, it should not be saved to the cache", %{cacheable_struct: cacheable_struct} do
      non_cacheable_struct =
        Struct.add(cacheable_struct, :response, %{cache_directive: %Belfrage.CacheControl{cacheability: "public"}})

      Belfrage.Cache.store(non_cacheable_struct)

      assert {:ok, :content_not_found} == Belfrage.Cache.Local.fetch(non_cacheable_struct)
    end

    test "when response is for a POST request it should not be saved to the cache", %{
      cacheable_struct: cacheable_struct
    } do
      non_cacheable_struct = Struct.add(cacheable_struct, :request, %{method: "POST"})

      Belfrage.Cache.store(non_cacheable_struct)

      assert {:ok, :content_not_found} == Belfrage.Cache.Local.fetch(non_cacheable_struct)
    end

    test "when response is not successful it should not be saved to the cache", %{cacheable_struct: cacheable_struct} do
      non_cacheable_struct = Struct.add(cacheable_struct, :response, %{http_status: 500})

      Belfrage.Cache.store(non_cacheable_struct)

      assert {:ok, :content_not_found} == Belfrage.Cache.Local.fetch(non_cacheable_struct)
    end

    test "when response is not publicly cacheable it should not be saved to the cache", %{
      cacheable_struct: cacheable_struct
    } do
      non_cacheable_struct =
        Struct.add(cacheable_struct, :response, %{
          cache_directive: %Belfrage.CacheControl{cacheability: "private", max_age: 30}
        })

      Belfrage.Cache.store(non_cacheable_struct)

      assert {:ok, :content_not_found} == Belfrage.Cache.Local.fetch(non_cacheable_struct)
    end

    test "when response is public, but max age is 0, it should be saved to the cache", %{
      cacheable_struct: cacheable_struct
    } do
      cacheable_struct =
        Struct.add(cacheable_struct, :response, %{
          cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 0}
        })

      Belfrage.Cache.store(cacheable_struct)
      :timer.sleep(1)

      assert {:ok, {:local, :stale}, _struct} = Belfrage.Cache.Local.fetch(cacheable_struct)
    end
  end
end
