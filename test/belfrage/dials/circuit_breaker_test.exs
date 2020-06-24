defmodule Belfrage.Dials.CircuitBreakerTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Dials

  test "state/0 returns dial state" do
    Belfrage.Helpers.FileIOMock
    |> expect(:read, fn _ -> {:ok, ~s({"circuit_breaker": "false"})} end)

    {:ok, pid} = Dials.CircuitBreaker.start_link([])
    assert Dials.CircuitBreaker.state() == false

    Process.exit(pid, :normal)
  end
end
