defmodule Belfrage.FallbackTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Struct
  alias Belfrage.Fallback

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
      id: "stale-cache-item",
      response: @cache_seeded_response,
      expires_in: :timer.hours(6),
      last_updated: Belfrage.Timer.now_ms() - :timer.seconds(31)
    )

    :ok
  end

  describe "fetching from cache in fallback mode" do
    test "when request status is 408 , add cached response to request hash" do
      struct = %Struct{
        private: %Struct.Private{
          loop_id: "ALoop"
        },
        request: %Struct.Request{
          request_hash: "stale-cache-item"
        },
        response: %Struct.Response{
          http_status: 408
        }
      }

      assert %Struct{response: %Struct.Response{fallback: true, http_status: 200}} =
                Fallback.fallback_if_required(struct)
    end

    test "when request status is greater than 499, add cached response to request hash" do
      struct = %Struct{
        private: %Struct.Private{
          loop_id: "ALoop"
        },
        request: %Struct.Request{
          request_hash: "stale-cache-item"
        },
        response: %Struct.Response{
          http_status: 500
        }
      }

      assert %Struct{response: %Struct.Response{fallback: true, http_status: 200}} =
                Fallback.fallback_if_required(struct)
    end

    test "when a request status is anything else, return the struct" do
      struct = %Struct{
        private: %Struct.Private{
          loop_id: "ALoop"
        },
        request: %Struct.Request{
          request_hash: "stale-cache-item"
        },
        response: %Struct.Response{
          http_status: 200
        }
      }

      assert struct == Fallback.fallback_if_required(struct)
    end
  end
end
