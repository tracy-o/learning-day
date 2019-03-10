defmodule Ingress.GuardianTest do
  use ExUnit.Case, async: true

  alias Ingress.Guardian

  setup do
    DynamicSupervisor.stop(Ingress.HandlersSupervisor)
    Process.sleep 10
    Ingress.HandlersSupervisor.start_handler("test")
    :ok
  end

  test "returns an origin pointer" do
    assert Guardian.origin("test") == {:ok, Application.get_env(:ingress, :origin)}
  end

  test "increments status codes counter and trips the circuit breaker" do
    for _ <- (1..30), do: Guardian.inc("test", Enum.random(500..504))
    Process.sleep 10
    assert Guardian.origin("test") == {:ok, "https://s3.aws.com/"}
  end

  test "resets after a specific time" do
    assert Guardian.origin("test") == {:ok, Application.get_env(:ingress, :origin)}

    for _ <- (1..30), do: Guardian.inc("test", Enum.random(500..504))
    Process.sleep 10
    assert Guardian.origin("test") == {:ok, "https://s3.aws.com/"}

    Process.sleep(Application.get_env(:ingress, :guardian_interval) + 100)

    assert Guardian.origin("test") == {:ok, Application.get_env(:ingress, :origin)}
  end
end
