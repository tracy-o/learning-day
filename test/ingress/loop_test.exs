defmodule Ingress.LoopTest do
  use ExUnit.Case, async: true

  alias Ingress.{Loop, LoopsSupervisor}
  alias Test.Support.StructHelper

  setup do
    DynamicSupervisor.stop(LoopsSupervisor)
    Process.sleep(5)
    LoopsSupervisor.start_loop("test")
    :ok
  end

  @failure_status_code Enum.random(500..504)

  @req_struct StructHelper.build(private: %{loop_id: "test"})
  @resp_struct StructHelper.build(
                 private: %{loop_id: "test"},
                 response: %{http_status: @failure_status_code}
               )

  test "returns a state pointer" do
    assert Loop.state(@req_struct) ==
             {:ok,
              %{counter: %{}, origin: "https://origin.bbc.com/", pipeline: ["MockTransformer"]}}
  end

  test "increments status codes counter and trips the circuit breaker" do
    for _ <- 1..30, do: Loop.inc(@resp_struct)
    {:ok, state} = Loop.state(@req_struct)

    assert %{
             counter: %{
               unquote(@failure_status_code) => 30,
               :errors => 30
             }
           } = state

    assert state.origin == "https://s3.aws.com/"
  end

  test "resets after a specific time" do
    {:ok, state} = Loop.state(@req_struct)
    assert state.origin == Application.get_env(:ingress, :origin)

    for _ <- 1..30, do: Loop.inc(@resp_struct)
    {:ok, state} = Loop.state(@req_struct)
    assert state.origin == "https://s3.aws.com/"

    Process.sleep(Application.get_env(:ingress, :errors_interval) + 100)

    {:ok, state} = Loop.state(@req_struct)
    assert state.origin == Application.get_env(:ingress, :origin)
  end
end
