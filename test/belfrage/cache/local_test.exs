defmodule Belfrage.Cache.LocalTest do
  use ExUnit.Case
  alias Belfrage.Cache
  alias Test.Support.StructHelper

  @response %Belfrage.Struct.Response{
    body: "hello!",
    headers: %{"content-type" => "application/json"},
    http_status: 200,
    cache_directive: %{cacheability: "public", max_age: 30}
  }

  setup do
    :ets.delete_all_objects(:cache)

    Test.Support.Helper.insert_cache_seed(
      id: "cache_fresh",
      response: @response,
      expires_in: :timer.hours(6),
      last_updated: Belfrage.Timer.now_ms()
    )

    Test.Support.Helper.insert_cache_seed(
      id: "stale_cache",
      response: @response,
      expires_in: :timer.hours(6),
      last_updated: Belfrage.Timer.now_ms() - :timer.seconds(31)
    )

    Test.Support.Helper.insert_cache_seed(
      id: "expired",
      response: @response,
      expires_in: :timer.hours(6),
      last_updated: Belfrage.Timer.now_ms() - (:timer.hours(6) + :timer.seconds(2))
    )

    :ok
  end

  describe "storing responses" do
    test "a new response" do
      struct =
        StructHelper.build(
          request: %{request_hash: "abc123"},
          response: %{
            headers: %{"content-type" => "application/json"},
            body: "hello!",
            http_status: 200,
            cache_directive: %{cacheability: "public", max_age: 30}
          }
        )

      assert {:ok, true} == Cache.Local.store(struct)

      assert [
               {:entry, "abc123", _cachex_determined_last_update, _cachex_expires_in,
                {%Belfrage.Struct.Response{
                   body: "hello!",
                   headers: %{"content-type" => "application/json"},
                   http_status: 200,
                   cache_directive: %{cacheability: "public", max_age: 30}
                 }, _belfrage_determined_last_updated}}
             ] = :ets.lookup(:cache, "abc123")
    end

    test "does not overwrite an existing fresh cache version" do
      struct =
        StructHelper.build(
          request: %{request_hash: "cache_fresh"},
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
      struct = StructHelper.build(request: %{request_hash: "cache_fresh"})

      assert {:ok, :fresh,
              %Belfrage.Struct.Response{
                body: "hello!",
                headers: %{"content-type" => "application/json"},
                http_status: 200
              }} = Cache.Local.fetch(struct)
    end

    test "fetches a stale cache" do
      struct = StructHelper.build(request: %{request_hash: "stale_cache"})

      assert {:ok, :stale,
              %Belfrage.Struct.Response{
                body: "hello!",
                headers: %{"content-type" => "application/json"},
                http_status: 200
              }} = Cache.Local.fetch(struct)
    end

    test "does not fetch an expired cache" do
      struct = StructHelper.build(request: %{request_hash: "expired"})

      assert {:ok, :content_not_found} = Cache.Local.fetch(struct)
    end
  end

  describe "cachex integration test" do
    test "stores and retrieves a response" do
      struct_without_response = StructHelper.build(request: %{request_hash: "asdf567"})

      struct_with_response =
        StructHelper.build(
          request: %{request_hash: "asdf567"},
          response: %{
            headers: %{"content-type" => "application/json"},
            body: "hello!",
            http_status: 200,
            cache_directive: %{cacheability: "public", max_age: 30}
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
