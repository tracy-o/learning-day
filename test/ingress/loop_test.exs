defmodule Ingress.LoopTest do
  use ExUnit.Case, async: true

  alias Ingress.{Loop, LoopsSupervisor}
  alias Test.Support.StructHelper

  setup do
    LoopsSupervisor.start_loop(["legacy"])
    LoopsSupervisor.start_loop(["webcore"])
    on_exit(fn -> LoopsSupervisor.kill_all() end)
  end

  @failure_status_code Enum.random(500..504)

  @req_struct StructHelper.build(private: %{loop_id: ["legacy"]})
  @req_struct_2 StructHelper.build(private: %{loop_id: ["webcore"]})
  @resp_struct StructHelper.build(
                 private: %{loop_id: ["legacy"], origin: "https://origin.bbc.com/"},
                 response: %{http_status: @failure_status_code}
               )
  @resp_struct_2 StructHelper.build(
                   private: %{loop_id: ["legacy"], origin: "https://s3.aws.com/"},
                   response: %{http_status: @failure_status_code}
                 )
  @non_error_resp_struct StructHelper.build(
                           private: %{loop_id: ["legacy"], origin: "https://origin.bbc.com/"},
                           response: %{http_status: 200}
                         )
  @non_error_resp_struct_2 StructHelper.build(
                             private: %{loop_id: ["legacy"], origin: "https://s3.aws.com/"},
                             response: %{http_status: 200}
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
               "https://origin.bbc.com/" => %{
                 unquote(@failure_status_code) => 30,
                 :errors => 30
               }
             }
           } = state

    assert state.origin == "https://s3.aws.com/"
  end

  describe "returns a different count per origin" do
    test "when there are errors" do
      for _ <- 1..15 do
        Loop.inc(@resp_struct)
      end

      for _ <- 1..9 do
        Loop.inc(@resp_struct_2)
      end

      assert {:ok,
              %{
                counter: %{
                  "https://origin.bbc.com/" => %{
                    unquote(@failure_status_code) => 15,
                    :errors => 15
                  },
                  "https://s3.aws.com/" => %{
                    unquote(@failure_status_code) => 9,
                    :errors => 9
                  }
                }
              }} = Loop.state(@resp_struct)
    end

    test "when there are no errors" do
      for _ <- 1..15 do
        Loop.inc(@non_error_resp_struct)
        Loop.inc(@non_error_resp_struct_2)
      end

      assert {:ok,
              %{
                counter: %{
                  "https://origin.bbc.com/" => %{
                    200 => 15
                  },
                  "https://s3.aws.com/" => %{
                    200 => 15
                  }
                }
              }} = Loop.state(@resp_struct)
    end

    test "when there are a mix of errors and success responses" do
      for _ <- 1..15 do
        Loop.inc(@non_error_resp_struct)
        Loop.inc(@resp_struct)
      end

      assert {:ok,
              %{
                counter: %{
                  "https://origin.bbc.com/" => %{
                    200 => 15,
                    unquote(@failure_status_code) => 15,
                    :errors => 15
                  }
                }
              }} = Loop.state(@resp_struct)
    end
  end

  test "resets after a specific time" do
    {:ok, state} = Loop.state(@req_struct)
    assert state.origin == Application.get_env(:ingress, :origin)

    for _ <- 1..30, do: Loop.inc(@resp_struct)
    {:ok, state} = Loop.state(@req_struct)
    assert state.origin == "https://s3.aws.com/"

    Process.sleep(Application.get_env(:ingress, :circuit_breaker_reset_interval) + 100)

    {:ok, state} = Loop.state(@req_struct)
    assert state.origin == Application.get_env(:ingress, :origin)
  end

  test "decides the origin based on the loop_id" do
    {:ok, state} = Loop.state(@req_struct)
    assert state.origin == Application.get_env(:ingress, :origin)

    {:ok, state} = Loop.state(@req_struct_2)
    assert state.origin == Application.get_env(:ingress, :webcore_lambda_name_progressive_web_app)
  end
end
