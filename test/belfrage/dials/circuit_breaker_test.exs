defmodule Belfrage.Dials.CircuitBreakerTest do
  use ExUnit.Case, async: true
  alias Belfrage.Dials

  test "state/0 returns dial state" do
    assert Dials.CircuitBreaker.state() |> is_boolean()
  end

  test "dial handles dials changed event" do
    dial_state = Dials.CircuitBreaker.state()

    GenServer.whereis(Dials.CircuitBreaker)
    |> GenServer.cast({:dials_changed, %{"circuit_breaker" => "#{!dial_state}"}})

    assert Dials.CircuitBreaker.state() == !dial_state
  end
end
