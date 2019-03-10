defmodule Ingress.LoopTest do
  use ExUnit.Case, async: true

  alias Ingress.{Loop, LoopsSupervisor}

  setup do
    DynamicSupervisor.stop(LoopsSupervisor)
    Process.sleep 10
    LoopsSupervisor.start_handler("test")
    :ok
  end

  test "returns an origin pointer" do
    assert Loop.origin("test") == {:ok, Application.get_env(:ingress, :origin)}
  end

  test "increments status codes counter and trips the circuit breaker" do
    for _ <- (1..30), do: Loop.inc("test", Enum.random(500..504))
    Process.sleep 10
    assert Loop.origin("test") == {:ok, "https://s3.aws.com/"}
  end

  test "resets after a specific time" do
    assert Loop.origin("test") == {:ok, Application.get_env(:ingress, :origin)}

    for _ <- (1..30), do: Loop.inc("test", Enum.random(500..504))
    Process.sleep 10
    assert Loop.origin("test") == {:ok, "https://s3.aws.com/"}

    Process.sleep(Application.get_env(:ingress, :errors_interval) + 100)

    assert Loop.origin("test") == {:ok, Application.get_env(:ingress, :origin)}
  end
end
