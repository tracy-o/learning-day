defmodule Belfrage.Transformers.CircuitBreakerTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  alias Belfrage.Transformers.CircuitBreaker
  alias Belfrage.Struct

  test "long_counter with no errors will not add circuit breaker response" do
    struct = %Struct{
      private: %Struct.Private{
        route_state_id: "SportVideos",
        origin: "https://origin.bbc.co.uk/",
        long_counter: %{"https://origin.bbc.co.uk/" => %{}},
        pipeline: ["CircuitBreaker"]
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

  test "a nil throughput will not add circuit breaker response" do
    struct = %Struct{
      private: %Struct.Private{
        route_state_id: "SportVideos",
        origin: "https://origin.bbc.co.uk/",
        throughput: nil,
        pipeline: ["CircuitBreaker"]
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

  test "throughput of 100 will not add circuit breaker response" do
    struct = %Struct{
      private: %Struct.Private{
        route_state_id: "SportVideos",
        origin: "https://origin.bbc.co.uk/",
        throughput: 100,
        pipeline: ["CircuitBreaker"]
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

  test "thoughput of 0 will return struct with response section with 500 status" do
    stub_dial(:circuit_breaker, "true")

    struct = %Struct{
      private: %Struct.Private{
        route_state_id: "SportVideos",
        origin: "https://origin.bbc.co.uk/",
        throughput: 0,
        pipeline: ["CircuitBreaker"]
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
    stub_dial(:circuit_breaker, "true")

    struct = %Struct{
      private: %Struct.Private{
        route_state_id: "SportVideos",
        origin: "https://origin.bbc.co.uk/",
        throughput: 0,
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
    stub_dial(:circuit_breaker, "true")

    struct = %Struct{
      private: %Struct.Private{
        route_state_id: "SportVideos",
        origin: "https://origin.bbc.co.uk/",
        throughput: 0,
        pipeline: ["CircuitBreaker"]
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
    stub_dial(:circuit_breaker, "true")

    struct = %Struct{
      private: %Struct.Private{
        route_state_id: "SportVideos",
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

  describe "when circuit breaker is active but disabled in dial" do
    test "no circuit breaker response should be returned" do
      stub_dial(:circuit_breaker, "false")

      struct = %Struct{
        private: %Struct.Private{
          route_state_id: "SportVideos",
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

      refute status == :stop_pipline
      refute origin == :belfrage_circuit_breaker
    end

    test "no circuit breaker response should be returned for multiple origins route" do
      stub_dial(:circuit_breaker, "false")

      struct = %Struct{
        private: %Struct.Private{
          route_state_id: "SportVideos",
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
end
