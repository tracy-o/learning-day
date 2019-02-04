defmodule Ingress.GuardianTest do
  use ExUnit.Case

  alias Ingress.Guardian

  setup do
    Process.sleep(Application.get_env(:ingress, :guardian_interval) + 200)
  end

  test "returns an origin pointer" do
    assert Guardian.origin(:guardian) == {:ok, Application.get_env(:ingress, :origin)}
  end

  test "increments status codes counter" do
    for _ <- (1..30), do: Guardian.inc(:guardian, Enum.random(500..504))
    assert Guardian.origin(:guardian) == {:ok, "https://s3.aws.com/"}
  end

  test "resets after a specific time" do
    assert Guardian.origin(:guardian) == {:ok, Application.get_env(:ingress, :origin)}

    for _ <- (1..30), do: Guardian.inc(:guardian, Enum.random(500..504))
    assert Guardian.origin(:guardian) == {:ok, "https://s3.aws.com/"}

    Process.sleep(Application.get_env(:ingress, :guardian_interval) + 100)

    assert Guardian.origin(:guardian) == {:ok, Application.get_env(:ingress, :origin)}
  end
end
