defmodule Belfrage.BelfrageCacheTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.RequestHash
  alias Belfrage.Struct
  alias Test.Support.StructHelper
  alias Belfrage.Clients.LambdaMock
  alias Belfrage.Cache

  @fresh_cache_get_request_struct StructHelper.build(
                                    request: %{
                                      country: "variant-1",
                                      method: "GET"
                                    },
                                    private: %{
                                      loop_id: ["test_loop"]
                                    }
                                  )

  @stale_cache_get_request_struct StructHelper.build(
                                    request: %{
                                      country: "variant-2",
                                      method: "GET"
                                    },
                                    private: %{
                                      loop_id: ["test_loop"]
                                    }
                                  )

  @web_core_lambda_response {:ok,
                             %{
                               "body" => ~s({"hi": "bonjour"}),
                               "headers" => %{"content-type" => "application/json", "cache-control" => 30},
                               "statusCode" => 200
                             }}

  @failed_web_core_lambda_response {:ok, %{"body" => "", "headers" => %{}, "statusCode" => 500}}

  @response %Belfrage.Struct.Response{
    body: ~s({"hi": "bonjour"}),
    headers: %{"content-type" => "application/json"},
    http_status: 200
  }

  @response %Belfrage.Struct.Response{
    body: ~s({"hi": "bonjour"}),
    headers: %{"content-type" => "application/json"},
    http_status: 200
  }

  @fallback_response %Belfrage.Struct.Response{
    body: ~s({"hi": "bonjour"}),
    headers: %{"content-type" => "application/json"},
    http_status: 200,
    fallback: true
  }

  setup do
    :ets.delete_all_objects(:cache)
    Belfrage.LoopsSupervisor.kill_all()

    Test.Support.Helper.insert_cache_seed(
      id: RequestHash.generate(@fresh_cache_get_request_struct).request.request_hash,
      response: @response,
      expires_in: :timer.hours(6),
      last_updated: Belfrage.Timer.now_ms(),
      cache_ttl: 30
    )

    Test.Support.Helper.insert_cache_seed(
      id: RequestHash.generate(@stale_cache_get_request_struct).request.request_hash,
      response: @response,
      expires_in: :timer.hours(6),
      last_updated: Belfrage.Timer.now_ms() - :timer.seconds(31),
      cache_ttl: 30
    )

    :ok
  end

  describe "a fresh cache" do
    test "serves a cached response" do
      assert %Belfrage.Struct{response: @response} = Belfrage.handle(@fresh_cache_get_request_struct)
    end

    test "served early from cache still increments loop" do
      Belfrage.handle(@fresh_cache_get_request_struct)

      assert {:ok,
              %{
                counter: %{
                  "pwa-lambda-function" => %{
                    200 => 1,
                    :errors => 0
                  }
                }
              }} = Belfrage.Loop.state(@fresh_cache_get_request_struct)
    end
  end

  describe "a stale cache" do
    test "uses service response" do
      LambdaMock
      |> expect(
        :call,
        fn "webcore-lambda-role-arn",
           "pwa-lambda-function",
           %{body: nil, headers: %{country: "variant-2"}, httpMethod: "GET"} ->
          @web_core_lambda_response
        end
      )

      assert struct = %Belfrage.Struct{response: @response} = Belfrage.handle(@stale_cache_get_request_struct)

      assert {:ok, :fresh, _} = Cache.Local.fetch(struct)
    end

    test "uses fallback when service fails" do
      LambdaMock
      |> expect(
        :call,
        fn "webcore-lambda-role-arn",
           "pwa-lambda-function",
           %{body: nil, headers: %{country: "variant-2"}, httpMethod: "GET"} ->
          @failed_web_core_lambda_response
        end
      )

      assert %Belfrage.Struct{response: @fallback_response} = Belfrage.handle(@stale_cache_get_request_struct)
    end
  end
end
