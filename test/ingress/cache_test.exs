defmodule Ingress.IngressCacheTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Ingress.RequestHash
  alias Ingress.Struct
  alias Test.Support.StructHelper
  alias Ingress.Clients.LambdaMock
  alias Ingress.Cache

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
                               "headers" => %{"content-type" => "application/json"},
                               "statusCode" => 200
                             }}

  @failed_web_core_lambda_response {:ok, %{"body" => "", "headers" => %{}, "statusCode" => 500}}

  @response %Ingress.Struct.Response{
    body: ~s({"hi": "bonjour"}),
    headers: %{"content-type" => "application/json"},
    http_status: 200,
    cacheable_content: true
  }

  @response %Ingress.Struct.Response{
    body: ~s({"hi": "bonjour"}),
    headers: %{"content-type" => "application/json"},
    http_status: 200,
    cacheable_content: true
  }

  @fallback_response %Ingress.Struct.Response{
    body: ~s({"hi": "bonjour"}),
    headers: %{"content-type" => "application/json"},
    http_status: 200,
    cacheable_content: true,
    fallback: true
  }

  setup do
    :ets.delete_all_objects(:cache)

    insert_seed_cache = fn [id: id, expires_in: expires_in, last_updated: last_updated] ->
      :ets.insert(
        :cache,
        {:entry, id, last_updated, expires_in, {@response, last_updated}}
      )
    end

    insert_seed_cache.(
      id: RequestHash.generate(@fresh_cache_get_request_struct).request.request_hash,
      expires_in: :timer.hours(6),
      last_updated: Ingress.Timer.now_ms()
    )

    insert_seed_cache.(
      id: RequestHash.generate(@stale_cache_get_request_struct).request.request_hash,
      expires_in: :timer.hours(6),
      last_updated: Ingress.Timer.now_ms() - :timer.seconds(31)
    )

    on_exit(fn -> Ingress.LoopsSupervisor.kill_all() end)

    :ok
  end

  describe "a fresh cache" do
    test "serves a cached response" do
      assert %Ingress.Struct{response: @response} =
               Ingress.handle(@fresh_cache_get_request_struct)
    end

    test "served early from cache still increments loop" do
      Ingress.handle(@fresh_cache_get_request_struct)

      assert {:ok,
              %{
                counter: %{
                  "presentation-layer" => %{
                    200 => 1,
                    :errors => 0
                  }
                }
              }} = Ingress.Loop.state(@fresh_cache_get_request_struct)
    end
  end

  describe "a stale cache" do
    test "uses service response" do
      LambdaMock
      |> expect(
        :call,
        fn "ec2-role",
           "presentation-role",
           "presentation-layer",
           %{body: nil, headers: %{country: "variant-2"}, httpMethod: "GET"} ->
          @web_core_lambda_response
        end
      )

      assert struct =
               %Ingress.Struct{response: @response} =
               Ingress.handle(@stale_cache_get_request_struct)

      assert {:ok, :fresh, _} = Cache.Local.fetch(struct)
    end

    test "uses fallback when service fails" do
      LambdaMock
      |> expect(
        :call,
        fn "ec2-role",
           "presentation-role",
           "presentation-layer",
           %{body: nil, headers: %{country: "variant-2"}, httpMethod: "GET"} ->
          @failed_web_core_lambda_response
        end
      )

      assert %Ingress.Struct{response: @fallback_response} =
               Ingress.handle(@stale_cache_get_request_struct)
    end
  end
end
