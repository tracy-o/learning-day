defmodule Belfrage.CircuitBreakerTest do
  use ExUnit.Case, async: true

  alias Belfrage.CircuitBreaker
  alias Belfrage.Struct
  alias Belfrage.Struct.{Response, Private}

  describe "apply_circuit_breaker/2" do
    def build_struct(error_threshold: error_threshold, error_count: error_count) do
      %Struct{
        private: %Private{
          origin: "https://origin.bbc.co.uk/",
          long_counter: %{"https://origin.bbc.co.uk/" => %{:errors => error_count}},
          circuit_breaker_error_threshold: error_threshold
        }
      }
    end

    test "if treshold exceeeded and dial on, circuit breaker applied" do
      input_struct = build_struct(error_threshold: 5, error_count: 10)

      {:active, output_struct} = CircuitBreaker.apply?(input_struct, true)

      assert %Struct{
               response: %Response{http_status: 500},
               private: %Private{origin: :belfrage_circuit_breaker}
             } = output_struct
    end

    test "if treshold exceeeded and dial off, circuit breaker not applied" do
      input_struct = build_struct(error_threshold: 5, error_count: 10)

      assert {:inactive, output_struct} = CircuitBreaker.apply?(input_struct, false)
      assert input_struct == output_struct
    end

    test "if below threshold and dial on, circuit breaker not applied" do
      input_struct = build_struct(error_threshold: 5, error_count: 1)

      assert {:inactive, output_struct} = CircuitBreaker.apply?(input_struct, true)
      assert input_struct == output_struct
    end

    test "if below threshold and dial off, circuit breaker not applied" do
      input_struct = build_struct(error_threshold: 5, error_count: 1)

      assert {:inactive, output_struct} = CircuitBreaker.apply?(input_struct, false)
      assert input_struct == output_struct
    end
  end
end
