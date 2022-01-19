defmodule Belfrage.CircuitBreakerTest do
  use ExUnit.Case, async: true

  alias Belfrage.CircuitBreaker
  alias Belfrage.Struct
  alias Belfrage.Struct.{Response, Private}

  describe "next_throughput/2" do
    test "next throughput is 0 when threshold is exceeded" do
      for t <- [0, 10, 20, 60, 100], do: assert(CircuitBreaker.next_throughput(true, t) == 0)
    end

    test "next throughput remains the same when at the maximum, and threshold is not exceeded" do
      assert CircuitBreaker.next_throughput(false, 100) == 100
    end

    test "next throughput is as expected when not at the maximum, and threshold is not exceeded" do
      assert CircuitBreaker.next_throughput(false, 0) == 10
      assert CircuitBreaker.next_throughput(false, 10) == 20
      assert CircuitBreaker.next_throughput(false, 20) == 60
      assert CircuitBreaker.next_throughput(false, 60) == 100
    end
  end

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

    test "if threshold exceeeded and dial on, circuit breaker applied" do
      input_struct = build_struct(error_threshold: 5, error_count: 10)

      {:active, output_struct} = CircuitBreaker.apply?(input_struct, true)

      assert %Struct{
               response: %Response{http_status: 500},
               private: %Private{origin: :belfrage_circuit_breaker}
             } = output_struct
    end

    test "if threshold exceeeded and dial off, circuit breaker not applied" do
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
