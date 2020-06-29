defmodule Belfrage.Dials.CircuitBreakerTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  import Belfrage.Dials.Defaults
  alias Belfrage.Dials

  @dial "circuit_breaker"
  @codec Application.get_env(:belfrage, :json_codec)
  @cosmos_dials File.read!("cosmos/dials.json") |> @codec.decode!()

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

    test "returns a state corresponds to dials.json" do
      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn _ -> {:ok, ~s({"circuit_breaker": "false"})} end)

      Dials.refresh_now()
      assert Dials.state() == %{"circuit_breaker" => "false"}
      assert Dials.CircuitBreaker.state() == false
    end
  end

  test "dial correctly handles changed event in which the dial boolean state is flipped" do
    dial_state = Dials.CircuitBreaker.state()

    GenServer.whereis(Dials.CircuitBreaker)
    |> GenServer.cast({:dials_changed, %{"circuit_breaker" => "#{!dial_state}"}})

    assert Dials.CircuitBreaker.state() == !dial_state
  end

  test "default/0 transforms and returns the string default state in Cosmos dials.json" do
    dial = @cosmos_dials |> Enum.find(&(&1["name"] == @dial))
    assert Dials.CircuitBreaker.default() == transform(dial["default-value"], @dial)
  end

  test "all dial values in Cosmos dials.json are transformed into booleans" do
    dial = @cosmos_dials |> Enum.find(&(&1["name"] == @dial))

    for dial <- dial["values"] do
      assert dial["value"] |> transform(@dial) |> is_boolean()
    end
  end
end
