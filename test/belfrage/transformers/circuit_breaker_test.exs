defmodule Belfrage.Transformers.CircuitBreakerTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Transformers.CircuitBreaker
  alias Belfrage.Struct

  def circuit_breaker_dial_enabled_mock do
    Belfrage.Helpers.FileIOMock
    |> expect(:read, fn _ -> {:ok, ~s({"circuit_breaker":"true"})} end)

    Belfrage.Dials.CircuitBreaker.start_link([])
  end

  def circuit_breaker_dial_disabled_mock do
    Belfrage.Helpers.FileIOMock
    |> expect(:read, fn _ -> {:ok, ~s({"circuit_breaker":"false"})} end)

    Belfrage.Dials.CircuitBreaker.start_link([])
  end

  test "long_counter with no errors will not add circuit breaker response" do
    struct = %Struct{
      private: %Struct.Private{
        loop_id: "SportVideos",
        origin: "https://origin.bbc.co.uk/",
        long_counter: %{"https://origin.bbc.co.uk/" => %{}},
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

  test "long_counter with no information at all will not add circuit breaker response" do
    struct = %Struct{
      private: %Struct.Private{
        loop_id: "SportVideos",
        origin: "https://origin.bbc.co.uk/",
        long_counter: %{},
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

  test "long_counter containing errors under threshold will not add circuit breaker response" do
    struct = %Struct{
      private: %Struct.Private{
        loop_id: "SportVideos",
        origin: "https://origin.bbc.co.uk/",
        long_counter: %{"https://origin.bbc.co.uk/" => %{501 => 4, :errors => 4}},
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

  test "long_counter containing errors over threshold will return struct with response section with 500 status" do
    circuit_breaker_dial_enabled_mock()

    struct = %Struct{
      private: %Struct.Private{
        loop_id: "SportVideos",
        origin: "https://origin.bbc.co.uk/",
        long_counter: %{"https://origin.bbc.co.uk/" => %{501 => 4, 502 => 4, 408 => 4, :errors => 12}},
        pipeline: ["CircuitBreaker"],
        circuit_breaker_error_threshold: 5
      }
    }

    assert {
             :stop_pipeline,
             %Belfrage.Struct{
               response: %Belfrage.Struct.Response{
                 http_status: 500
               }
             }
           } = CircuitBreaker.call([], struct)
  end

  test "when circuit breaker is active, the origin represents this" do
    circuit_breaker_dial_enabled_mock()

    struct = %Struct{
      private: %Struct.Private{
        loop_id: "SportVideos",
        origin: "https://origin.bbc.co.uk/",
        long_counter: %{"https://origin.bbc.co.uk/" => %{501 => 4, 502 => 4, 408 => 4, :errors => 12}},
        pipeline: ["CircuitBreaker"],
        circuit_breaker_error_threshold: 5
      }
    }

    assert {
             :stop_pipeline,
             %Belfrage.Struct{
               private: %Belfrage.Struct.Private{
                 origin: :belfrage_circuit_breaker
               }
             }
           } = CircuitBreaker.call([], struct)
  end

  test "when circuit breaker is active, the response body is returned as an empty string" do
    circuit_breaker_dial_enabled_mock()

    struct = %Struct{
      private: %Struct.Private{
        loop_id: "SportVideos",
        origin: "https://origin.bbc.co.uk/",
        long_counter: %{"https://origin.bbc.co.uk/" => %{501 => 4, 502 => 4, 408 => 4, :errors => 12}},
        pipeline: ["CircuitBreaker"],
        circuit_breaker_error_threshold: 5
      }
    }

    assert {
             :stop_pipeline,
             %Belfrage.Struct{
               response: %Belfrage.Struct.Response{
                 body: ""
               }
             }
           } = CircuitBreaker.call([], struct)
  end

  test "multiple origins will not add circuit breaker response when no errors for current origin" do
    circuit_breaker_dial_enabled_mock()

    struct = %Struct{
      private: %Struct.Private{
        loop_id: "SportVideos",
        origin: "https://origin2.bbc.co.uk/",
        long_counter: %{
          "https://origin.bbc.co.uk/" => %{501 => 6, :errors => 6},
          "https://origin2.bbc.co.uk/" => %{501 => 4, :errors => 4},
          "https://origin3.bbc.co.uk/" => %{501 => 7, :errors => 7}
        },
        pipeline: ["CircuitBreaker"],
        circuit_breaker_error_threshold: 5
      }
    }

    assert {
             :ok,
             %Struct{
               response: %Struct.Response{
                 http_status: nil
               }
             }
           } = CircuitBreaker.call([], struct)
  end

  test "multiple origins will return struct with http 500 response when no errors for current origin" do
    circuit_breaker_dial_enabled_mock()

    struct = %Struct{
      private: %Struct.Private{
        loop_id: "SportVideos",
        origin: "https://origin2.bbc.co.uk/",
        long_counter: %{
          "https://origin.bbc.co.uk/" => %{501 => 1, :errors => 1},
          "https://origin2.bbc.co.uk/" => %{501 => 6, :errors => 6},
          "https://origin3.bbc.co.uk/" => %{501 => 2, :errors => 2}
        },
        pipeline: ["CircuitBreaker"],
        circuit_breaker_error_threshold: 5
      }
    }

    assert {
             :stop_pipeline,
             %Struct{
               response: %Struct.Response{
                 http_status: 500
               }
             }
           } = CircuitBreaker.call([], struct)
  end

  test "when circuit breaker is active but disabled in dial, no circuit breaker response should be returned" do
    circuit_breaker_dial_disabled_mock()

    struct = %Struct{
      private: %Struct.Private{
        loop_id: "SportVideos",
        origin: "https://origin.bbc.co.uk/",
        long_counter: %{"https://origin.bbc.co.uk/" => %{501 => 4, 502 => 4, 408 => 4, :errors => 12}},
        pipeline: ["CircuitBreaker"],
        circuit_breaker_error_threshold: 5
      }
    }

    {
      status,
      %Belfrage.Struct{
        private: %Belfrage.Struct.Private{
          origin: origin
        }
      }
    } = CircuitBreaker.call([], struct)

    assert status == :ok
    assert origin == "https://origin.bbc.co.uk/"

    refute status == :stop_pipline
    refute origin == :belfrage_circuit_breaker
  end

  test "when circuit breaker is active but disabled in dial, no circuit breaker response should be returned for multiple origins route" do
    circuit_breaker_dial_disabled_mock()

    struct = %Struct{
      private: %Struct.Private{
        loop_id: "SportVideos",
        origin: "https://origin2.bbc.co.uk/",
        long_counter: %{
          "https://origin.bbc.co.uk/" => %{501 => 6, :errors => 6},
          "https://origin2.bbc.co.uk/" => %{501 => 4, :errors => 4},
          "https://origin3.bbc.co.uk/" => %{501 => 7, :errors => 7}
        },
        pipeline: ["CircuitBreaker"],
        circuit_breaker_error_threshold: 5
      }
    }

    assert {
             :ok,
             %Struct{
               response: %Struct.Response{
                 http_status: nil
               }
             }
           } = CircuitBreaker.call([], struct)
  end
end
