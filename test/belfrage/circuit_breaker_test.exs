defmodule Belfrage.CircuitBreakerTest do
  use ExUnit.Case, async: true

  alias Belfrage.CircuitBreaker
  alias Belfrage.Envelope
  alias Belfrage.Envelope.Private

  describe "next_throughput/3" do
    test "next throughput is 0 when threshold is exceeded and circuit breaker dial is set to true" do
      for t <- [0, 20, 60, 100], do: assert(CircuitBreaker.next_throughput(true, t, true) == 0)
    end

    test "next throughput is 100 when threshold is exceeded and circuit breaker dial is set to false" do
      for t <- [0, 20, 60, 100], do: assert(CircuitBreaker.next_throughput(true, t, false) == 100)
    end

    test "next throughput remains the same when at the maximum, and threshold is not exceeded and circuit breaker dial is set to true" do
      assert CircuitBreaker.next_throughput(false, 100, true) == 100
    end

    test "next throughput remains the same when at the maximum, and threshold is not exceeded and circuit breaker dial is set to false" do
      assert CircuitBreaker.next_throughput(false, 100, false) == 100
    end

    test "next throughput is as expected when not at the maximum, threshold is not exceeded and circuit breaker dial is set to true" do
      assert CircuitBreaker.next_throughput(false, 0, true) == 20
      assert CircuitBreaker.next_throughput(false, 20, true) == 60
      assert CircuitBreaker.next_throughput(false, 60, true) == 100
    end

    test "next throughput is as expected when not at the maximum, threshold is not exceeded and circuit breaker dial is set to false" do
      assert CircuitBreaker.next_throughput(false, 0, false) == 100
      assert CircuitBreaker.next_throughput(false, 20, false) == 100
      assert CircuitBreaker.next_throughput(false, 60, false) == 100
    end
  end

  describe "maybe_apply/2" do
    def build_envelope(throughput) do
      %Envelope{
        private: %Private{
          origin: "https://origin.bbc.co.uk/",
          throughput: throughput
        }
      }
    end

    test "if throughput is 0 and dial off, circuit breaker not applied" do
      input_envelope = build_envelope(0)

      assert {:not_applied, output_envelope} = CircuitBreaker.maybe_apply(input_envelope, false)
      assert input_envelope == output_envelope
    end

    test "if throughput is 100 and dial off, circuit breaker not applied" do
      input_envelope = build_envelope(100)

      assert {:not_applied, output_envelope} = CircuitBreaker.maybe_apply(input_envelope, false)
      assert input_envelope == output_envelope
    end

    test "if throughput is 0 and dial on, circuit breaker applied to 100% of envelopes (nearest 10%)" do
      assert check_cb_applied(0) == 1.0
    end

    test "if throughput is 20 and dial on, circuit breaker applied to 80% of envelopes (nearest 10%)" do
      assert check_cb_applied(20) == 0.8
    end

    test "if throughput is 60 and dial on, circuit breaker applied to 40% of envelopes (nearest 10%)" do
      assert check_cb_applied(60) == 0.4
    end

    test "if throughput is 100 and dial on, circuit breaker applied to 0% of envelopes (nearest 10%)" do
      assert check_cb_applied(100) == 0
    end

    def check_cb_applied(throughput, no_of_envelopes \\ 10_000, round_to \\ 1000) do
      applied =
        throughput
        |> build_envelope()
        |> List.duplicate(no_of_envelopes)
        |> Enum.map(&CircuitBreaker.maybe_apply/1)
        |> Enum.count(&CircuitBreaker.applied?/1)
        |> round_to_nearest_multiple(round_to)

      applied / no_of_envelopes
    end

    defp round_to_nearest_multiple(n, factor) do
      trunc(round(n / factor) * factor)
    end
  end
end
