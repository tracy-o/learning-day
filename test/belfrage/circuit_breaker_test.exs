defmodule Belfrage.CircuitBreakerTest do
  use ExUnit.Case, async: true

  alias Belfrage.CircuitBreaker
  alias Belfrage.Struct
  alias Belfrage.Struct.Private

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

  describe "maybe_activate/2" do
    def build_struct(throughput) do
      %Struct{
        private: %Private{
          origin: "https://origin.bbc.co.uk/",
          throughput: throughput
        }
      }
    end

    test "if throughput is 0 and dial off, circuit breaker not applied" do
      input_struct = build_struct(0)

      assert {:inactive, output_struct} = CircuitBreaker.maybe_activate(input_struct, false)
      assert input_struct == output_struct
    end

    test "if throughput is 100 and dial off, circuit breaker not applied" do
      input_struct = build_struct(100)

      assert {:inactive, output_struct} = CircuitBreaker.maybe_activate(input_struct, false)
      assert input_struct == output_struct
    end

    test "if throughput is 0 and dial on, circuit breaker applied to 100% of structs (nearest 10%)" do
      assert check_cb_applied(0) == 1.0
    end

    test "if throughput is 10 and dial on, circuit breaker applied to 90% of structs (nearest 10%)" do
      assert check_cb_applied(10) == 0.9
    end

    test "if throughput is 20 and dial on, circuit breaker applied to 80% of structs (nearest 10%)" do
      assert check_cb_applied(20) == 0.8
    end

    test "if throughput is 60 and dial on, circuit breaker applied to 40% of structs (nearest 10%)" do
      assert check_cb_applied(60) == 0.4
    end

    test "if throughput is 100 and dial on, circuit breaker applied to 0% of structs (nearest 10%)" do
      assert check_cb_applied(100) == 0
    end

    def check_cb_applied(throughput, no_of_structs \\ 10_000, round_to \\ 1000) do
      applied =
        throughput
        |> build_struct()
        |> List.duplicate(no_of_structs)
        |> Enum.map(&CircuitBreaker.maybe_activate/1)
        |> Enum.count(&CircuitBreaker.activated?/1)
        |> round_to_nearest_multiple(round_to)

      applied / no_of_structs
    end

    defp round_to_nearest_multiple(n, factor) do
      trunc(round(n / factor) * factor)
    end
  end
end
