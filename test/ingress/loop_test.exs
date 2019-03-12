defmodule Ingress.LoopTest do
  use ExUnit.Case, async: true

  alias Ingress.{Loop, LoopsSupervisor}

  setup do
    DynamicSupervisor.stop(LoopsSupervisor)
    Process.sleep 5
    LoopsSupervisor.start_loop("test")
    :ok
  end

  test "returns a state pointer" do
    assert Loop.state("test") == {:ok, %{counter: %{}, origin: "https://origin.bbc.com/", pipeline: [:lambda_prep]}}
  end

  test "increments status codes counter and trips the circuit breaker" do
    for _ <- (1..30), do: Loop.inc("test", Enum.random(500..504))
    {:ok, state} = Loop.state("test")
    assert state.counter !=  %{}
    assert state.origin ==  "https://s3.aws.com/"
  end

  test "resets after a specific time" do
    {:ok, state} = Loop.state("test")
    assert state.origin == Application.get_env(:ingress, :origin)

    for _ <- (1..30), do: Loop.inc("test", Enum.random(500..504))
    {:ok, state} = Loop.state("test")
    assert state.origin == "https://s3.aws.com/"

    Process.sleep(Application.get_env(:ingress, :errors_interval) + 100)

    {:ok, state} = Loop.state("test")
    assert state.origin == Application.get_env(:ingress, :origin)
  end
end
