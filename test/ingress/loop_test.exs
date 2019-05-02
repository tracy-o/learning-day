defmodule Ingress.LoopTest do
  use ExUnit.Case, async: true

  alias Ingress.{Loop, LoopsSupervisor, Struct, LoopsRegistry}
  alias Test.Support.StructHelper

  setup do
    LoopsSupervisor.start_loop("legacy")
    LoopsSupervisor.start_loop("webcore")
    on_exit(fn -> LoopsSupervisor.killall() end)
  end

  @failure_status_code Enum.random(500..504)

  @req_struct StructHelper.build(private: %{loop_id: "legacy"})
  @req_struct_2 StructHelper.build(private: %{loop_id: "webcore"})
  @resp_struct StructHelper.build(
                 private: %{loop_id: "legacy"},
                 response: %{http_status: @failure_status_code}
               )

  test "returns a state pointer" do
    assert Loop.state(@req_struct) ==
             {:ok,
              %{counter: %{}, origin: "https://origin.bbc.com/", pipeline: ["MyTransformer1"]}}
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

  test "decides the origin based on the loop_id" do
    {:ok, state} = Loop.state(@req_struct)
    assert state.origin == Application.get_env(:ingress, :origin)

    {:ok, state} = Loop.state(@req_struct_2)
    assert state.origin == Application.get_env(:ingress, :lambda_presentation_layer)
  end
end
