defmodule Belfrage.Cache.LocalTest do
  use ExUnit.Case
  alias Belfrage.Cache
  alias Test.Support.StructHelper

  setup do
    :ets.delete_all_objects(:cache)

    insert_seed_cache = fn [id: id, expires_in: expires_in, last_updated: last_updated] ->
      :ets.insert(
        :cache,
        {:entry, id, last_updated, expires_in,
         {%Belfrage.Struct.Response{
            body: "hello!",
            headers: %{"content-type" => "application/json"},
            http_status: 200
          }, last_updated}}
      )
    end

    insert_seed_cache.(
      id: "cache_fresh",
      expires_in: :timer.hours(6),
      last_updated: Belfrage.Timer.now_ms()
    )

    insert_seed_cache.(
      id: "stale_cache",
      expires_in: :timer.hours(6),
      last_updated: Belfrage.Timer.now_ms() - :timer.seconds(31)
    )

    insert_seed_cache.(
      id: "expired",
      expires_in: :timer.hours(6),
      last_updated: Belfrage.Timer.now_ms() - (:timer.hours(6) + :timer.seconds(1))
    )

    :ok
  end

  describe "storing responses" do
    test "a new response" do
      struct =
        StructHelper.build(
          request: %{request_hash: "abc123"},
          private: %{cache_ttl: 30},
          response: %{
            headers: %{"content-type" => "application/json"},
            body: "hello!",
            http_status: 200
          }
        )

      assert {:ok, true} == Cache.Local.store(struct)

      assert [
               {:entry, "abc123", _cachex_determined_last_update, _cachex_expires_in,
                {%Belfrage.Struct.Response{
                   body: "hello!",
                   headers: %{"content-type" => "application/json"},
                   http_status: 200
                 }, _belfrage_determined_last_updated}}
             ] = :ets.lookup(:cache, "abc123")
    end

    test "does not overwrite an existing fresh cache version" do
      struct =
        StructHelper.build(
          request: %{request_hash: "cache_fresh"},
          private: %{cache_ttl: 30},
          response: %{
            headers: %{"content-type" => "application/json"},
            body: "hello!",
            http_status: 200
          }
        )

      assert {:ok, false} == Cache.Local.store(struct)
    end

    test "updates an expired cached response" do
      struct =
        StructHelper.build(
          request: %{request_hash: "expired"},
          private: %{cache_ttl: 30},
          response: %{
            headers: %{"content-type" => "application/json"},
            body: "hello!",
            http_status: 200
          }
        )

      assert {:ok, true} == Cache.Local.store(struct)
    end

    test "updates a stale cached response" do
      struct =
        StructHelper.build(
          request: %{request_hash: "stale_cache"},
          private: %{cache_ttl: 30},
          response: %{
            headers: %{"content-type" => "application/json"},
            body: "hello!",
            http_status: 200
          }
        )

      assert {:ok, true} == Cache.Local.store(struct)
    end
  end

  describe "fetching a cached response" do
    test "fetches a fresh cache" do
      struct = StructHelper.build(request: %{request_hash: "cache_fresh"}, private: %{cache_ttl: 30})

      assert {:ok, :fresh,
              %Belfrage.Struct.Response{
                body: "hello!",
                headers: %{"content-type" => "application/json"},
                http_status: 200
              }} = Cache.Local.fetch(struct)
    end

    test "fetches a stale cache" do
      struct = StructHelper.build(request: %{request_hash: "stale_cache"}, private: %{cache_ttl: 30})

      assert {:ok, :stale,
              %Belfrage.Struct.Response{
                body: "hello!",
                headers: %{"content-type" => "application/json"},
                http_status: 200
              }} = Cache.Local.fetch(struct)
    end

    test "does not fetch an expired cache" do
      struct = StructHelper.build(request: %{request_hash: "expired"}, private: %{cache_ttl: 30})

      assert {:ok, :content_not_found} = Cache.Local.fetch(struct)
    end
  end

  describe "cachex integration test" do
    test "stores and retrieves a response" do
      struct_without_response = StructHelper.build(request: %{request_hash: "asdf567"}, private: %{cache_ttl: 30})

      struct_with_response =
        StructHelper.build(
          request: %{request_hash: "asdf567"},
          private: %{cache_ttl: 30},
          response: %{
            headers: %{"content-type" => "application/json"},
            body: "hello!",
            http_status: 200
          }
        )

      assert {:ok, true} == Cache.Local.store(struct_with_response)

      assert {:ok, :fresh,
              %Belfrage.Struct.Response{
                body: "hello!",
                headers: %{"content-type" => "application/json"},
                http_status: 200
              }} = Cache.Local.fetch(struct_without_response)
    end
  end
end
