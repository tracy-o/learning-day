defmodule Belfrage.Transformers.CircuitBreakerTest do
  use ExUnit.Case

  alias Belfrage.Transformers.CircuitBreaker
  alias Belfrage.Struct

  test "counter with no errors will return same struct" do
    struct = %Struct{
      private: %{
        loop_id: "SportVideos",
        origin: "https://origin.bbc.co.uk/",
        counter: %{"https://origin.bbc.co.uk/" => %{}},
        pipeline: ["CircuitBreaker"],
        circuit_breaker_error_threshold: 5
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
        counter: %{"https://origin.bbc.co.uk/" => %{501 => 4, :errors => 4}},
        pipeline: ["CircuitBreaker"],
        circuit_breaker_error_threshold: 5
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

  test "counter containing errors over threshold will return struct with response section with 500 status" do
    struct = %Struct{
      private: %{
        loop_id: "SportVideos",
        origin: "https://origin.bbc.co.uk/",
        counter: %{"https://origin.bbc.co.uk/" => %{501 => 4, 502 => 4, 408 => 4, :errors => 12}},
        pipeline: ["CircuitBreaker"],
        circuit_breaker_error_threshold: 5
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
