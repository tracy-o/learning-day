defmodule Belfrage.Dials.CircuitBreakerTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  alias Belfrage.Dials

  describe "state/0" do
    setup do
      Dials.clear()
    end

    test "returns a default boolean state on init" do
      assert Dials.state() == %{}
      assert Dials.CircuitBreaker.state() |> is_boolean()
    end

    test "returns a default boolean state when dials.json is malformed" do
      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn _ -> {:ok, ~s(malformed json)} end)

      Dials.refresh_now()
      assert Dials.state() == %{}
      assert Dials.CircuitBreaker.state() |> is_boolean()
    end

    test "returns a state which corresponds to the dials.json" do
      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn _ -> {:ok, ~s({"circuit_breaker": "false"})} end)

      Dials.refresh_now()
      assert Dials.state() == %{"circuit_breaker" => "false"}
      assert Dials.CircuitBreaker.state() == false
    end
  end

  test "default/0  returns a boolean state" do
    assert Dials.CircuitBreaker.default() |> is_boolean()
  end

  test "dial correctly handles changed event in which the dial boolean state is flipped" do
    dial_state = Dials.CircuitBreaker.state()
    GenServer.cast(Dials.CircuitBreaker, {:dials_changed, %{"circuit_breaker" => "#{!dial_state}"}})

    assert Dials.CircuitBreaker.state() == !dial_state
  end
end
