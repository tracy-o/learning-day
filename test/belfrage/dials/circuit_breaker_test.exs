defmodule Belfrage.Dials.CircuitBreakerTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Dials
  @initial_state false

  test "state/0 returns dial state" do
    Belfrage.Helpers.FileIOMock
    |> expect(:read, fn _ -> {:ok, ~s({"circuit_breaker": "#{@initial_state}"})} end)

    Dials.CircuitBreaker.start_link([])
    assert Dials.CircuitBreaker.state() == @initial_state
  end

  test "dial handles dials changed event" do
    Belfrage.Helpers.FileIOMock
    |> expect(:read, fn _ -> {:ok, ~s({"circuit_breaker": "#{@initial_state}"})} end)

    {:ok, pid} = Dials.CircuitBreaker.start_link([])

    GenServer.cast(pid, {:dials_changed, %{"circuit_breaker" => "#{!@initial_state}"}})
    assert Dials.CircuitBreaker.state() == !@initial_state
  end
end
