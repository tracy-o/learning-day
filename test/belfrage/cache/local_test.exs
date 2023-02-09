defmodule Belfrage.Cache.LocalTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  import ExUnit.CaptureLog
  import Belfrage.Test.CachingHelper

  alias Belfrage.Cache
  alias Belfrage.Envelope
  alias Belfrage.Timer
  import Belfrage.Test.MetricsHelper, only: [assert_metric: 2]
  require Cachex.Spec

  defmodule TestCache do
    def touch(_cache, _key) do
      exit(:some_reason)
    end

    def fetch(_cache, _key) do
      {:ok, %Envelope{response: Fixtures.Envelope.successful_response()}}
    end
  end

  setup do
    stub_dial(:cache_enabled, "true")

    put_into_cache(cache_key("fresh"), Fixtures.Envelope.successful_response())

    put_into_cache(cache_key("stale"), %{
      Fixtures.Envelope.successful_response()
      | cache_last_updated: Belfrage.Timer.now_ms() - :timer.seconds(31)
    })

    :ok
  end

  describe "storing responses" do
    setup do
      %{
        envelope: %Envelope{
          request: %Envelope.Request{request_hash: cache_key("abc123")},
          response: %Envelope.Response{
            headers: %{"content-type" => "application/json"},
            body: "hello!",
            http_status: 200,
            cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 30}
          }
        }
      }
    end

    test "a new response", %{envelope: envelope} do
      assert {:ok, true} == Cache.Local.store(envelope)

      assert [
               {:entry, _key, _cachex_determined_last_update, _cachex_expires_in,
                %Belfrage.Envelope.Response{
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

    test "a new response for a personalised route", %{envelope: envelope} do
      envelope = Envelope.add(envelope, :private, %{personalised_route: true})

      assert {:ok, true} == Cache.Local.store(envelope, make_stale: true)

      assert [
               {:entry, _key, _cachex_determined_last_update, _cachex_expires_in,
                %Belfrage.Envelope.Response{
                  personalised_route: true
                }}
             ] = :ets.lookup(:cache, cache_key("abc123"))
    end

    test "a new response as stale", %{envelope: envelope} do
      assert {:ok, true} == Cache.Local.store(envelope, make_stale: true)

      assert [
               {:entry, _key, _cachex_determined_last_update, _cachex_expires_in,
                %Belfrage.Envelope.Response{
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
      envelope = %Envelope{
        request: %Envelope.Request{request_hash: cache_key("fresh")},
        response: %Envelope.Response{
          headers: %{"content-type" => "application/json"},
          body: "hello!",
          http_status: 200,
          cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 30},
          cache_last_updated: Belfrage.Timer.now_ms()
        }
      }

      assert {:ok, false} == Cache.Local.store(envelope)
    end

    test "updates a stale cached response" do
      envelope = %Envelope{
        request: %Envelope.Request{request_hash: cache_key("stale")},
        response: %Envelope.Response{
          headers: %{"content-type" => "application/json"},
          body: "hello!",
          http_status: 200,
          cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 30}
        }
      }

      assert {:ok, true} == Cache.Local.store(envelope)
    end

    test "touches the cache on access" do
      envelope = %Envelope{
        request: %Envelope.Request{request_hash: cache_key("fresh")},
        response: %Envelope.Response{
          headers: %{"content-type" => "application/json"},
          body: "hello!",
          http_status: 200,
          cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 30}
        }
      }

      assert {:ok, {:local, :fresh}, _} = Cache.Local.fetch(envelope)

      :timer.sleep(1000)

      assert {:ok, {:local, :fresh}, _} = Cache.Local.fetch(envelope)

      [{:entry, _key, ets_updated, _expires, response}] = :ets.lookup(:cache, cache_key("fresh"))

      assert ets_updated > response.cache_last_updated
    end
  end

  describe "Fetches a cached response" do
    test "that is fresh" do
      envelope = %Envelope{request: %Envelope.Request{request_hash: cache_key("fresh")}}

      assert {:ok, {:local, :fresh},
              %Belfrage.Envelope.Response{
                body: "hello!",
                headers: %{"content-type" => "application/json"},
                http_status: 200
              }} = Cache.Local.fetch(envelope)
    end

    test "that is stale" do
      envelope = %Envelope{request: %Envelope.Request{request_hash: cache_key("stale")}}

      assert {:ok, {:local, :stale},
              %Belfrage.Envelope.Response{
                body: "hello!",
                headers: %{"content-type" => "application/json"},
                http_status: 200
              }} = Cache.Local.fetch(envelope)
    end
  end

  describe "When an exit signal is sent during an attempt to fetch a cached response" do
    setup do
      {:ok,
       caching_module: TestCache, envelope: %Envelope{request: %Envelope.Request{request_hash: cache_key("fresh")}}}
    end

    test "the expected message is logged", %{envelope: envelope, caching_module: caching_module} do
      captured_log = capture_log(fn -> Cache.Local.fetch(envelope, caching_module) end)

      assert captured_log =~ "level\":\"error\""
      assert captured_log =~ "\"metadata\":{}"
      assert captured_log =~ "\"msg\":\"Attempt to fetch from the local cache failed: :some_reason"
    end

    test "the correct event is emitted", %{envelope: envelope, caching_module: caching_module} do
      assert_metric(~w(cache local fetch_exit)a, fn -> Cache.Local.fetch(envelope, caching_module) end)
    end

    test "the correct tuple is returned", %{envelope: envelope, caching_module: caching_module} do
      assert {:ok, :content_not_found} == Cache.Local.fetch(envelope, caching_module)
    end
  end

  describe "cachex integration test" do
    test "stores and retrieves a response" do
      envelope_without_response = %Envelope{request: %Envelope.Request{request_hash: cache_key("asdf567")}}

      envelope_with_response = %Envelope{
        request: %Envelope.Request{request_hash: cache_key("asdf567")},
        response: %Envelope.Response{
          headers: %{"content-type" => "application/json"},
          body: "hello!",
          http_status: 200,
          cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 30}
        }
      }

      assert {:ok, true} == Cache.Local.store(envelope_with_response)

      assert {:ok, {:local, :fresh},
              %Belfrage.Envelope.Response{
                body: "hello!",
                headers: %{"content-type" => "application/json"},
                http_status: 200
              }} = Cache.Local.fetch(envelope_without_response)
    end
  end

  describe "local caching is dependant on the cache_enabled dial" do
    test "it successfully stores the response when dial is true" do
      stub_dial(:cache_enabled, "true")

      envelope = %Envelope{
        request: %Envelope.Request{request_hash: cache_key("abc123")},
        response: %Envelope.Response{
          headers: %{"content-type" => "application/json"},
          body: "hello!",
          http_status: 200,
          cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 30}
        }
      }

      assert {:ok, true} == Cache.Local.store(envelope)
    end

    test "it does not store the response when dial is false" do
      stub_dial(:cache_enabled, "false")

      envelope = %Envelope{
        request: %Envelope.Request{request_hash: cache_key("abc123")},
        response: %Envelope.Response{
          headers: %{"content-type" => "application/json"},
          body: "hello!",
          http_status: 200,
          cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 30}
        }
      }

      assert {:ok, false} == Cache.Local.store(envelope)
    end

    test "it successfully fetches a response when dial is true" do
      stub_dial(:cache_enabled, "true")

      envelope = %Envelope{request: %Envelope.Request{request_hash: cache_key("fresh")}}

      assert {:ok, {:local, :fresh},
              %Belfrage.Envelope.Response{
                body: "hello!",
                headers: %{"content-type" => "application/json"},
                http_status: 200
              }} = Cache.Local.fetch(envelope)
    end

    test "it does not fetch a response when dial is false" do
      stub_dial(:cache_enabled, "false")

      envelope = %Envelope{request: %Envelope.Request{request_hash: cache_key("fresh")}}

      assert {:ok, :content_not_found} == Cache.Local.fetch(envelope)
    end
  end
end
