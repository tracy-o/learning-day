defmodule Belfrage.LoopTest do
  use ExUnit.Case, async: true

  alias Belfrage.{Loop, LoopsSupervisor}
  alias Belfrage.Struct

  setup do
    LoopsSupervisor.start_loop("ProxyPass")
    LoopsSupervisor.start_loop("SportVideos")
    on_exit(fn -> LoopsSupervisor.kill_all() end)
  end

  @failure_status_code Enum.random(500..504)

  @legacy_request_struct %Struct{private: %Struct.Private{loop_id: "ProxyPass"}}

  @resp_struct %Struct{
    private: %Struct.Private{loop_id: "ProxyPass", origin: "https://origin.bbc.com/"},
    response: %Struct.Response{http_status: @failure_status_code, fallback: nil}
  }
  @resp_struct_2 %Struct{
    private: %Struct.Private{loop_id: "ProxyPass", origin: "https://s3.aws.com/"},
    response: %Struct.Response{http_status: @failure_status_code, fallback: nil}
  }
  @non_error_resp_struct %Struct{
    private: %Struct.Private{loop_id: "ProxyPass", origin: "https://origin.bbc.com/"},
    response: %Struct.Response{http_status: 200, fallback: nil}
  }
  @non_error_resp_struct_2 %Struct{
    private: %Struct.Private{loop_id: "ProxyPass", origin: "https://s3.aws.com/"},
    response: %Struct.Response{http_status: 200, fallback: nil}
  }

  @fallback_resp_struct %Struct{
    private: %Struct.Private{loop_id: "ProxyPass", origin: "https://origin.bbc.com/"},
    response: %Struct.Response{http_status: 200, fallback: true}
  }

  test "returns a state pointer" do
    assert Loop.state(@legacy_request_struct) ==
             {:ok,
              %{
                counter: %{},
                long_counter: %{},
                origin: "http://origin.bbc.com",
                owner: "belfrage-team@bbc.co.uk",
                runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
                platform: OriginSimulator,
                pipeline: ["CircuitBreaker"],
                resp_pipeline: [],
                circuit_breaker_error_threshold: 100,
                loop_id: "ProxyPass"
              }}
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

  test "resets counter after a specific time" do
    for _ <- 1..30, do: Loop.inc(@resp_struct)
    {:ok, state} = Loop.state(@legacy_request_struct)
    assert state.counter.errors == 30

    Process.sleep(Application.get_env(:belfrage, :short_counter_reset_interval) + 1)

    {:ok, state} = Loop.state(@legacy_request_struct)
    assert false == Map.has_key?(state.counter, :error), "Loop should have reset"
  end

  test "resets long_counter after a specific time" do
    for _ <- 1..30, do: Loop.inc(@resp_struct)
    {:ok, state} = Loop.state(@legacy_request_struct)
    assert state.counter.errors == 30

    Process.sleep(Application.get_env(:belfrage, :long_counter_reset_interval) + 1)

    {:ok, state} = Loop.state(@legacy_request_struct)
    assert false == Map.has_key?(state.long_counter, :error), "Loop should have reset"
  end

  describe "when in fallback" do
    test "it increments both the status and fallback counters" do
      for _ <- 1..30, do: Loop.inc(@fallback_resp_struct)
      {:ok, state} = Loop.state(@legacy_request_struct)

      assert %{
               counter: %{
                 "https://origin.bbc.com/" => %{
                   :fallback => 30,
                   200 => 30
                 }
               }
             } = state
    end

    test "it does not increment fallback for successful responses" do
      for _ <- 1..15 do
        Loop.inc(@non_error_resp_struct)
        Loop.inc(@resp_struct)
      end

      assert {:ok, %{counter: counter}} = Loop.state(@resp_struct)

      assert not Map.has_key?(counter, :fallback)
    end
  end
end
