defmodule Belfrage.RequestTransformers.CircuitBreakerTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  alias Belfrage.RequestTransformers.CircuitBreaker
  alias Belfrage.Envelope

  test "counter with no errors will not add circuit breaker response" do
    envelope = %Envelope{
      private: %Envelope.Private{
        route_state_id: "SportVideos",
        origin: "https://origin.bbc.co.uk/",
        counter: %{"https://origin.bbc.co.uk/" => %{}},
        request_pipeline: ["CircuitBreaker"]
      }
    }

    assert {
             :ok,
             %Envelope{
               response: %{
                 http_status: nil
               }
             }
           } = CircuitBreaker.call(envelope)
  end

  test "a nil throughput will not add circuit breaker response" do
    envelope = %Envelope{
      private: %Envelope.Private{
        route_state_id: "SportVideos",
        origin: "https://origin.bbc.co.uk/",
        throughput: nil,
        request_pipeline: ["CircuitBreaker"]
      }
    }

    assert {
             :ok,
             %Envelope{
               response: %{
                 http_status: nil
               }
             }
           } = CircuitBreaker.call(envelope)
  end

  test "throughput of 100 will not add circuit breaker response" do
    envelope = %Envelope{
      private: %Envelope.Private{
        route_state_id: "SportVideos",
        origin: "https://origin.bbc.co.uk/",
        throughput: 100,
        request_pipeline: ["CircuitBreaker"]
      }
    }

    assert {
             :ok,
             %Belfrage.Envelope{
               response: %Belfrage.Envelope.Response{
                 http_status: nil
               }
             }
           } = CircuitBreaker.call(envelope)
  end

  test "thoughput of 0 will return envelope with response section with 500 status" do
    stub_dial(:circuit_breaker, "true")

    envelope = %Envelope{
      private: %Envelope.Private{
        route_state_id: "SportVideos",
        origin: "https://origin.bbc.co.uk/",
        throughput: 0,
        request_pipeline: ["CircuitBreaker"]
      }
    }

    assert {
             :stop,
             %Belfrage.Envelope{
               response: %Belfrage.Envelope.Response{
                 http_status: 500
               }
             }
           } = CircuitBreaker.call(envelope)
  end

  test "when circuit breaker is active, the origin represents this" do
    stub_dial(:circuit_breaker, "true")

    envelope = %Envelope{
      private: %Envelope.Private{
        route_state_id: "SportVideos",
        origin: "https://origin.bbc.co.uk/",
        throughput: 0,
        request_pipeline: ["CircuitBreaker"],
        circuit_breaker_error_threshold: 5
      }
    }

    assert {
             :stop,
             %Belfrage.Envelope{
               private: %Belfrage.Envelope.Private{
                 origin: :belfrage_circuit_breaker
               }
             }
           } = CircuitBreaker.call(envelope)
  end

  test "when circuit breaker is active, the response body is returned as an empty string" do
    stub_dial(:circuit_breaker, "true")

    envelope = %Envelope{
      private: %Envelope.Private{
        route_state_id: "SportVideos",
        origin: "https://origin.bbc.co.uk/",
        throughput: 0,
        request_pipeline: ["CircuitBreaker"]
      }
    }

    assert {
             :stop,
             %Belfrage.Envelope{
               response: %Belfrage.Envelope.Response{
                 body: ""
               }
             }
           } = CircuitBreaker.call(envelope)
  end

  test "multiple origins will not add circuit breaker response when no errors for current origin" do
    stub_dial(:circuit_breaker, "true")

    envelope = %Envelope{
      private: %Envelope.Private{
        route_state_id: "SportVideos",
        origin: "https://origin2.bbc.co.uk/",
        counter: %{
          "https://origin.bbc.co.uk/" => %{501 => 6, :errors => 6},
          "https://origin2.bbc.co.uk/" => %{501 => 4, :errors => 4},
          "https://origin3.bbc.co.uk/" => %{501 => 7, :errors => 7}
        },
        request_pipeline: ["CircuitBreaker"],
        circuit_breaker_error_threshold: 5
      }
    }

    assert {
             :ok,
             %Envelope{
               response: %Envelope.Response{
                 http_status: nil
               }
             }
           } = CircuitBreaker.call(envelope)
  end

  describe "when circuit breaker is active but disabled in dial" do
    test "no circuit breaker response should be returned" do
      stub_dial(:circuit_breaker, "false")

      envelope = %Envelope{
        private: %Envelope.Private{
          route_state_id: "SportVideos",
          origin: "https://origin.bbc.co.uk/",
          counter: %{"https://origin.bbc.co.uk/" => %{501 => 4, 502 => 4, 408 => 4, :errors => 12}},
          request_pipeline: ["CircuitBreaker"],
          circuit_breaker_error_threshold: 5
        }
      }

      {
        status,
        %Belfrage.Envelope{
          private: %Belfrage.Envelope.Private{
            origin: origin
          }
        }
      } = CircuitBreaker.call(envelope)

      refute status == :stop
      refute origin == :belfrage_circuit_breaker
    end

    test "no circuit breaker response should be returned for multiple origins route" do
      stub_dial(:circuit_breaker, "false")

      envelope = %Envelope{
        private: %Envelope.Private{
          route_state_id: "SportVideos",
          origin: "https://origin2.bbc.co.uk/",
          counter: %{
            "https://origin.bbc.co.uk/" => %{501 => 6, :errors => 6},
            "https://origin2.bbc.co.uk/" => %{501 => 4, :errors => 4},
            "https://origin3.bbc.co.uk/" => %{501 => 7, :errors => 7}
          },
          request_pipeline: ["CircuitBreaker"],
          circuit_breaker_error_threshold: 5
        }
      }

      assert {
               :ok,
               %Envelope{
                 response: %Envelope.Response{
                   http_status: nil
                 }
               }
             } = CircuitBreaker.call(envelope)
    end
  end
end
