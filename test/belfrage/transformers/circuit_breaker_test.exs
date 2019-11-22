defmodule Belfrage.Transformers.CircuitBreakerTest do
  use ExUnit.Case

  alias Belfrage.Transformers.CircuitBreaker
  alias Test.Support.StructHelper
  alias Belfrage.Struct

  test "counter with no errors will return same struct" do
    struct = %Struct{
      private: %{
        loop_id: "SportVideos",
        origin: "https://origin.bbc.co.uk/",
        counter: %{"https://origin.bbc.co.uk/" => %{}},
        pipeline: []
      }
    }

    assert {
             :ok,
             %Struct{
               response: %{
                 http_status: nil
               }
             }
           } = CircuitBreaker.call([], struct)
  end

  test "counter containing errors under threshold will return same struct" do
    struct = %Struct{
      private: %{
        loop_id: "SportVideos",
        origin: "https://origin.bbc.co.uk/",
        counter: %{"https://origin.bbc.co.uk/" => %{501 => 1, :errors => 1}},
        pipeline: []
      }
    }

    assert {
             :ok,
             %Belfrage.Struct{
               response: %Belfrage.Struct.Response{
                 http_status: nil
               }
             }
           } = CircuitBreaker.call([], struct)
  end

  test "counter containing errors over threshold will return struct with response section added" do
    struct = %Struct{
      private: %{
        loop_id: "SportVideos",
        origin: "https://origin.bbc.co.uk/",
        counter: %{"https://origin.bbc.co.uk/" => %{501 => 2, :errors => 2}},
        pipeline: []
      }
    }

    assert {
             :ok,
             %Belfrage.Struct{
               response: %Belfrage.Struct.Response{
                 http_status: 500
               }
             }
           } = CircuitBreaker.call([], struct)
  end
end
