defmodule Belfrage.Cache.LocalTest do
  use ExUnit.Case, async: true
  import Belfrage.Test.CachingHelper

  alias Belfrage.Cache
  alias Belfrage.Struct
  alias Belfrage.Timer

  @response %Belfrage.Struct.Response{
    body: "hello!",
    headers: %{"content-type" => "application/json"},
    http_status: 200,
    cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 30},
    cache_last_updated: Belfrage.Timer.now_ms()
  }

  setup do
    put_into_cache(cache_key("fresh"), @response)
    put_into_cache(cache_key("stale"), %{@response | cache_last_updated: Belfrage.Timer.now_ms() - :timer.seconds(31)})

    :ok
  end

  describe "storing responses" do
    test "a new response" do
      struct = %Struct{
        request: %Struct.Request{request_hash: cache_key("abc123")},
        response: %Struct.Response{
          headers: %{"content-type" => "application/json"},
          body: "hello!",
          http_status: 200,
          cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 30}
        }
      }

      assert {:ok, true} == Cache.Local.store(struct)

      assert [
               {:entry, _key, _cachex_determined_last_update, _cachex_expires_in,
                %Belfrage.Struct.Response{
                  body: "hello!",
                  headers: %{"content-type" => "application/json"},
                  http_status: 200,
                  cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: max_age},
                  cache_last_updated: cache_last_updated
                }}
             ] = :ets.lookup(:cache, cache_key("abc123"))

      refute cache_last_updated == nil
      refute Timer.stale?(cache_last_updated, max_age)
    end

    test "a new response as stale" do
      struct = %Struct{
        request: %Struct.Request{request_hash: cache_key("abc123")},
        response: %Struct.Response{
          headers: %{"content-type" => "application/json"},
          body: "hello!",
          http_status: 200,
          cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 30}
        }
      }

      assert {:ok, true} == Cache.Local.store(struct, make_stale: true)

      assert [
               {:entry, _key, _cachex_determined_last_update, _cachex_expires_in,
                %Belfrage.Struct.Response{
                  body: "hello!",
                  headers: %{"content-type" => "application/json"},
                  http_status: 200,
                  cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: max_age},
                  cache_last_updated: cache_last_updated
                }}
             ] = :ets.lookup(:cache, cache_key("abc123"))

      assert cache_last_updated
      assert Timer.stale?(cache_last_updated, max_age)
    end

    test "does not overwrite an existing fresh cache version" do
      struct = %Struct{
        request: %Struct.Request{request_hash: cache_key("fresh")},
        response: %Struct.Response{
          headers: %{"content-type" => "application/json"},
          body: "hello!",
          http_status: 200,
          cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 30},
          cache_last_updated: Belfrage.Timer.now_ms()
        }
      }

      assert {:ok, false} == Cache.Local.store(struct)
    end

    test "updates a stale cached response" do
      struct = %Struct{
        request: %Struct.Request{request_hash: cache_key("stale")},
        response: %Struct.Response{
          headers: %{"content-type" => "application/json"},
          body: "hello!",
          http_status: 200,
          cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 30}
        }
      }

      assert {:ok, true} == Cache.Local.store(struct)
    end

    test "touches the cache on access" do
      struct = %Struct{
        request: %Struct.Request{request_hash: cache_key("fresh")},
        response: %Struct.Response{
          headers: %{"content-type" => "application/json"},
          body: "hello!",
          http_status: 200,
          cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 30}
        }
      }

      assert {:ok, {:local, :fresh}, _} = Cache.Local.fetch(struct)

      :timer.sleep(1000)

      assert {:ok, {:local, :fresh}, _} = Cache.Local.fetch(struct)

      [{:entry, _key, ets_updated, _expires, response}] = :ets.lookup(:cache, cache_key("fresh"))

      assert ets_updated > response.cache_last_updated
    end
  end

  describe "fetching a cached response" do
    test "fetches a fresh cache" do
      struct = %Struct{request: %Struct.Request{request_hash: cache_key("fresh")}}

      assert {:ok, {:local, :fresh},
              %Belfrage.Struct.Response{
                body: "hello!",
                headers: %{"content-type" => "application/json"},
                http_status: 200
              }} = Cache.Local.fetch(struct)
    end

    test "fetches a stale cache" do
      struct = %Struct{request: %Struct.Request{request_hash: cache_key("stale")}}

      assert {:ok, {:local, :stale},
              %Belfrage.Struct.Response{
                body: "hello!",
                headers: %{"content-type" => "application/json"},
                http_status: 200
              }} = Cache.Local.fetch(struct)
    end
  end

  describe "cachex integration test" do
    test "stores and retrieves a response" do
      struct_without_response = %Struct{request: %Struct.Request{request_hash: cache_key("asdf567")}}

      struct_with_response = %Struct{
        request: %Struct.Request{request_hash: cache_key("asdf567")},
        response: %Struct.Response{
          headers: %{"content-type" => "application/json"},
          body: "hello!",
          http_status: 200,
          cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 30}
        }
      }

      assert {:ok, true} == Cache.Local.store(struct_with_response)

      assert {:ok, {:local, :fresh},
              %Belfrage.Struct.Response{
                body: "hello!",
                headers: %{"content-type" => "application/json"},
                http_status: 200
              }} = Cache.Local.fetch(struct_without_response)
    end
  end
end
