defmodule Belfrage.Dials.CircuitBreakerTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  alias Belfrage.Dials.Poller
  alias Belfrage.Dials.CircuitBreaker

  describe "state/0" do
    setup do
      Poller.clear()
    end

    test "returns a default boolean state on init" do
      assert Poller.state() == %{}
      assert CircuitBreaker.state() |> is_boolean()
    end

    test "returns a default boolean state when dials.json is malformed" do
      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn _ -> {:ok, ~s(malformed json)} end)

      Poller.refresh_now()
      assert Poller.state() == %{}
      assert CircuitBreaker.state() |> is_boolean()
    end

    test "returns a state which corresponds to the dials.json" do
      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn _ -> {:ok, ~s({"circuit_breaker": "false"})} end)

      Poller.refresh_now()
      assert Poller.state() == %{"circuit_breaker" => "false"}
      assert CircuitBreaker.state() == false
    end
  end

  test "default/0  returns a boolean state" do
    assert CircuitBreaker.default() |> is_boolean()
  end

  test "dial correctly handles changed event in which the dial boolean state is flipped" do
    dial_state = CircuitBreaker.state()
    GenServer.cast(CircuitBreaker, {:dials_changed, %{"circuit_breaker" => "#{!dial_state}"}})

    assert CircuitBreaker.state() == !dial_state
  end
end
