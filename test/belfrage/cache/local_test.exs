defmodule Belfrage.Cache.LocalTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureLog
  import Belfrage.Test.CachingHelper

  alias Belfrage.Cache
  alias Belfrage.Struct
  alias Belfrage.Timer
  import Belfrage.Test.MetricsHelper, only: [assert_metric: 2]
  require Cachex.Spec

  defmodule TestCache do
    def touch(_cache, _key) do
      exit(:some_reason)
    end

    def fetch(_cache, _key) do
      {:ok, %Struct{response: Fixtures.Struct.successful_response()}}
    end
  end

  setup do
    put_into_cache(cache_key("fresh"), Fixtures.Struct.successful_response())

    put_into_cache(cache_key("stale"), %{
      Fixtures.Struct.successful_response()
      | cache_last_updated: Belfrage.Timer.now_ms() - :timer.seconds(31)
    })

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

  describe "Fetches a cached response" do
    test "that is fresh" do
      struct = %Struct{request: %Struct.Request{request_hash: cache_key("fresh")}}

      assert {:ok, {:local, :fresh},
              %Belfrage.Struct.Response{
                body: "hello!",
                headers: %{"content-type" => "application/json"},
                http_status: 200
              }} = Cache.Local.fetch(struct)
    end

    test "that is stale" do
      struct = %Struct{request: %Struct.Request{request_hash: cache_key("stale")}}

      assert {:ok, {:local, :stale},
              %Belfrage.Struct.Response{
                body: "hello!",
                headers: %{"content-type" => "application/json"},
                http_status: 200
              }} = Cache.Local.fetch(struct)
    end
  end

  describe "When an exit signal is sent during an attempt to fetch a cached response" do
    setup do
      {:ok, caching_module: TestCache, struct: %Struct{request: %Struct.Request{request_hash: cache_key("fresh")}}}
    end

    test "the expected message is logged", %{struct: struct, caching_module: caching_module} do
      captured_log = capture_log(fn -> Cache.Local.fetch(struct, caching_module) end)

      assert captured_log =~
               "level\":\"error\",\"metadata\":{},\"msg\":\"Attempt to fetch from the local cache failed: :some_reason"
    end

    test "the correct event is emitted", %{struct: struct, caching_module: caching_module} do
      assert_metric(~w(cache local fetch_exit)a, fn -> Cache.Local.fetch(struct, caching_module) end)
    end

    test "the correct tuple is returned", %{struct: struct, caching_module: caching_module} do
      assert {:ok, :content_not_found} == Cache.Local.fetch(struct, caching_module)
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
