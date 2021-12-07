defmodule Belfrage.LoopTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.{Struct, Loop, RouteSpec}

  @failure_status_code Enum.random(500..504)

  @loop_id "ProxyPass"

  @legacy_request_struct %Struct{private: %Struct.Private{loop_id: @loop_id}}

  @resp_struct %Struct{
    private: %Struct.Private{loop_id: @loop_id, origin: "https://origin.bbc.com/"},
    response: %Struct.Response{http_status: @failure_status_code, fallback: nil}
  }
  @resp_struct_2 %Struct{
    private: %Struct.Private{loop_id: @loop_id, origin: "https://s3.aws.com/"},
    response: %Struct.Response{http_status: @failure_status_code, fallback: nil}
  }
  @non_error_resp_struct %Struct{
    private: %Struct.Private{loop_id: @loop_id, origin: "https://origin.bbc.com/"},
    response: %Struct.Response{http_status: 200, fallback: nil}
  }
  @non_error_resp_struct_2 %Struct{
    private: %Struct.Private{loop_id: @loop_id, origin: "https://s3.aws.com/"},
    response: %Struct.Response{http_status: 200, fallback: nil}
  }

  @fallback_resp_struct %Struct{
    private: %Struct.Private{loop_id: @loop_id, origin: "https://origin.bbc.com/"},
    response: %Struct.Response{http_status: 200, fallback: true}
  }

  setup do
    start_loop()
    :ok
  end

  test "returns a state pointer" do
    route_spec =
      @loop_id
      |> String.to_atom()
      |> RouteSpec.specs_for()
      |> Map.from_struct()

    assert Loop.state(@legacy_request_struct) ==
             {:ok, Map.merge(route_spec, %{loop_id: @loop_id, counter: %{}, long_counter: %{}})}
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
    # Set the interval just for this specifc test and restart the loop
    stop_loop()
    interval = 100
    set_env(:short_counter_reset_interval, interval)
    start_loop()

    for _ <- 1..30, do: Loop.inc(@resp_struct)
    {:ok, state} = Loop.state(@legacy_request_struct)
    assert state.counter.errors == 30

    Process.sleep(interval + 1)

    {:ok, state} = Loop.state(@legacy_request_struct)
    assert false == Map.has_key?(state.counter, :error), "Loop should have reset"
  end

  test "resets long_counter after a specific time" do
    # Set the interval just for this specifc test and restart the loop
    stop_loop()
    interval = 100
    set_env(:long_counter_reset_interval, interval)
    start_loop()

    for _ <- 1..30, do: Loop.inc(@resp_struct)
    {:ok, state} = Loop.state(@legacy_request_struct)
    assert state.counter.errors == 30

    Process.sleep(interval + 1)

    {:ok, state} = Loop.state(@legacy_request_struct)
    assert false == Map.has_key?(state.long_counter, :error), "Loop should have reset"
  end

  describe "when in fallback" do
    test "it only increments the fallback counter" do
      for _ <- 1..30, do: Loop.inc(@fallback_resp_struct)
      {:ok, state} = Loop.state(@legacy_request_struct)

      assert %{
               counter: %{
                 "https://origin.bbc.com/" => %{
                   :fallback => 30
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

  test "exits when fetch_loop_timeout reached" do
    assert catch_exit(Loop.state(@resp_struct, 0)) ==
             {:timeout,
              {GenServer, :call, [{:via, Registry, {Belfrage.LoopsRegistry, {Belfrage.Loop, "ProxyPass"}}}, :state, 0]}}
  end

  defp start_loop() do
    start_supervised!({Loop, @loop_id})
  end

  defp stop_loop() do
    # TODO: Replace with stop_supervised! once we upgrade to Elixir 1.12.
    # stop_supervisor currently returns an error if the process that is stopped
    # is temporary, like the loop process here.
    stop_supervised(Loop)
  end

  defp set_env(name, value) do
    original_value = Application.get_env(:belfrage, name)
    Application.put_env(:belfrage, name, value)
    on_exit(fn -> Application.put_env(:belfrage, name, original_value) end)
  end
end
