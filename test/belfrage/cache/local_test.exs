defmodule Belfrage.Cache.LocalTest do
  use ExUnit.Case, async: true

  import Test.Support.Helper, only: [start_test_cache: 2]

  alias Belfrage.Cache
  alias Belfrage.Struct

  @cache :cache_local_test
  @response %Belfrage.Struct.Response{
    body: "hello!",
    headers: %{"content-type" => "application/json"},
    http_status: 200,
    cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 30},
    cache_last_updated: Belfrage.Timer.now_ms()
  }

  setup do
    {:ok, _pid} = start_test_cache(@cache, size: 10)

    Test.Support.Helper.insert_cache_seed(
      @cache,
      id: "cache_fresh",
      response: @response,
      expires_in: :timer.hours(6),
      last_updated: Belfrage.Timer.now_ms()
    )

    Test.Support.Helper.insert_cache_seed(
      @cache,
      id: "stale_cache",
      response: %{@response | cache_last_updated: Belfrage.Timer.now_ms() - :timer.seconds(31)},
      expires_in: :timer.hours(6),
      last_updated: Belfrage.Timer.now_ms() - :timer.seconds(31)
    )

    Test.Support.Helper.insert_cache_seed(
      @cache,
      id: "expired",
      response: %{@response | cache_last_updated: Belfrage.Timer.now_ms() - (:timer.hours(6) + :timer.seconds(2))},
      expires_in: :timer.hours(6),
      last_updated: Belfrage.Timer.now_ms() - (:timer.hours(6) + :timer.seconds(2))
    )

    :ok
  end

  describe "storing responses" do
    test "a new response" do
      struct = %Struct{
        request: %Struct.Request{request_hash: "abc123"},
        response: %Struct.Response{
          headers: %{"content-type" => "application/json"},
          body: "hello!",
          http_status: 200,
          cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 30}
        }
      }

      assert {:ok, true} == Cache.Local.store(struct, @cache)

      assert [
               {:entry, "abc123", _cachex_determined_last_update, _cachex_expires_in,
                %Belfrage.Struct.Response{
                  body: "hello!",
                  headers: %{"content-type" => "application/json"},
                  http_status: 200,
                  cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 30},
                  cache_last_updated: cache_last_updated
                }}
             ] = :ets.lookup(@cache, "abc123")

      refute cache_last_updated == nil
    end

    test "does not overwrite an existing fresh cache version" do
      struct = %Struct{
        request: %Struct.Request{request_hash: "cache_fresh"},
        response: %Struct.Response{
          headers: %{"content-type" => "application/json"},
          body: "hello!",
          http_status: 200,
          cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 30},
          cache_last_updated: Belfrage.Timer.now_ms()
        }
      }

      assert {:ok, false} == Cache.Local.store(struct, @cache)
    end

    test "updates an expired cached response" do
      struct = %Struct{
        request: %Struct.Request{request_hash: "expired"},
        response: %Struct.Response{
          headers: %{"content-type" => "application/json"},
          body: "hello!",
          http_status: 200,
          cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 30}
        }
      }

      assert {:ok, true} == Cache.Local.store(struct, @cache)
    end

    test "updates a stale cached response" do
      struct = %Struct{
        request: %Struct.Request{request_hash: "stale_cache"},
        response: %Struct.Response{
          headers: %{"content-type" => "application/json"},
          body: "hello!",
          http_status: 200,
          cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 30}
        }
      }

      assert {:ok, true} == Cache.Local.store(struct, @cache)
    end

    test "touches the cache on access" do
      struct = %Struct{
        request: %Struct.Request{request_hash: "cache_fresh"},
        response: %Struct.Response{
          headers: %{"content-type" => "application/json"},
          body: "hello!",
          http_status: 200,
          cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 30}
        }
      }

      assert {:ok, :fresh, _} = Cache.Local.fetch(struct, @cache)

      :timer.sleep(1000)

      assert {:ok, :fresh, _} = Cache.Local.fetch(struct, @cache)

      [{:entry, "cache_fresh", ets_updated, _expires, response}] = :ets.lookup(@cache, "cache_fresh")

      assert ets_updated > response.cache_last_updated
    end
  end

  describe "fetching a cached response" do
    test "fetches a fresh cache" do
      struct = %Struct{request: %Struct.Request{request_hash: "cache_fresh"}}

      assert {:ok, :fresh,
              %Belfrage.Struct.Response{
                body: "hello!",
                headers: %{"content-type" => "application/json"},
                http_status: 200
              }} = Cache.Local.fetch(struct, @cache)
    end

    test "fetches a stale cache" do
      struct = %Struct{request: %Struct.Request{request_hash: "stale_cache"}}

      assert {:ok, :stale,
              %Belfrage.Struct.Response{
                body: "hello!",
                headers: %{"content-type" => "application/json"},
                http_status: 200
              }} = Cache.Local.fetch(struct, @cache)
    end

    test "does not fetch an expired cache" do
      struct = %Struct{request: %Struct.Request{request_hash: "expired"}}

      assert {:ok, :content_not_found} = Cache.Local.fetch(struct, @cache)
    end
  end

  describe "cachex integration test" do
    test "stores and retrieves a response" do
      struct_without_response = %Struct{request: %Struct.Request{request_hash: "asdf567"}}

      struct_with_response = %Struct{
        request: %Struct.Request{request_hash: "asdf567"},
        response: %Struct.Response{
          headers: %{"content-type" => "application/json"},
          body: "hello!",
          http_status: 200,
          cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 30}
        }
      }

      assert {:ok, true} == Cache.Local.store(struct_with_response, @cache)

      assert {:ok, :fresh,
              %Belfrage.Struct.Response{
                body: "hello!",
                headers: %{"content-type" => "application/json"},
                http_status: 200
              }} = Cache.Local.fetch(struct_without_response, @cache)
    end
  end
end
