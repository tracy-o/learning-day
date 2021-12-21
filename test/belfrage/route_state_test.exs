defmodule Belfrage.RouteStateTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox
  import Belfrage.Test.RoutingHelper

  alias Belfrage.{Struct, RouteState, RouteSpec}

  @failure_status_code Enum.random(500..504)

  @route_state_id "RouteStateTestRouteSpec"

  define_route(@route_state_id, %{platform: Webcore})

  @legacy_request_struct %Struct{private: %Struct.Private{route_state_id: @route_state_id}}

  @resp_struct %Struct{
    private: %Struct.Private{route_state_id: @route_state_id, origin: "https://origin.bbc.com/"},
    response: %Struct.Response{http_status: @failure_status_code, fallback: nil}
  }
  @resp_struct_2 %Struct{
    private: %Struct.Private{route_state_id: @route_state_id, origin: "https://s3.aws.com/"},
    response: %Struct.Response{http_status: @failure_status_code, fallback: nil}
  }
  @non_error_resp_struct %Struct{
    private: %Struct.Private{route_state_id: @route_state_id, origin: "https://origin.bbc.com/"},
    response: %Struct.Response{http_status: 200, fallback: nil}
  }
  @non_error_resp_struct_2 %Struct{
    private: %Struct.Private{route_state_id: @route_state_id, origin: "https://s3.aws.com/"},
    response: %Struct.Response{http_status: 200, fallback: nil}
  }

  @fallback_resp_struct %Struct{
    private: %Struct.Private{route_state_id: @route_state_id, origin: "https://origin.bbc.com/"},
    response: %Struct.Response{http_status: 200, fallback: true}
  }

  setup do
    start_route_state()
    :ok
  end

  test "returns a state pointer" do
    route_spec =
      @route_state_id
      |> String.to_atom()
      |> RouteSpec.specs_for()
      |> Map.from_struct()

    assert RouteState.state(@legacy_request_struct) ==
             {:ok, Map.merge(route_spec, %{route_state_id: @route_state_id, counter: %{}, long_counter: %{}})}
  end

  describe "returns a different count per origin" do
    test "when there are errors" do
      for _ <- 1..15 do
        RouteState.inc(@resp_struct)
      end

      for _ <- 1..9 do
        RouteState.inc(@resp_struct_2)
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
              }} = RouteState.state(@resp_struct)
    end

    test "when there are no errors" do
      for _ <- 1..15 do
        RouteState.inc(@non_error_resp_struct)
        RouteState.inc(@non_error_resp_struct_2)
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
              }} = RouteState.state(@resp_struct)
    end

    test "when there are a mix of errors and success responses" do
      for _ <- 1..15 do
        RouteState.inc(@non_error_resp_struct)
        RouteState.inc(@resp_struct)
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
              }} = RouteState.state(@resp_struct)
    end
  end

  test "resets counter after a specific time" do
    # Set the interval just for this specifc test and restart the route_state
    stop_route_state()
    interval = 100
    set_env(:short_counter_reset_interval, interval)
    start_route_state()

    for _ <- 1..30, do: RouteState.inc(@resp_struct)
    {:ok, state} = RouteState.state(@legacy_request_struct)
    assert state.counter.errors == 30

    Process.sleep(interval + 1)

    {:ok, state} = RouteState.state(@legacy_request_struct)
    assert false == Map.has_key?(state.counter, :error), "RouteState should have reset"
  end

  test "resets long_counter after a specific time" do
    # Set the interval just for this specifc test and restart the route_state
    stop_route_state()
    interval = 100
    set_env(:long_counter_reset_interval, interval)
    start_route_state()

    for _ <- 1..30, do: RouteState.inc(@resp_struct)
    {:ok, state} = RouteState.state(@legacy_request_struct)
    assert state.counter.errors == 30

    Process.sleep(interval + 1)

    {:ok, state} = RouteState.state(@legacy_request_struct)
    assert false == Map.has_key?(state.long_counter, :error), "RouteState should have reset"
  end

  describe "when in fallback" do
    test "it only increments the fallback counter" do
      for _ <- 1..30, do: RouteState.inc(@fallback_resp_struct)
      {:ok, state} = RouteState.state(@legacy_request_struct)

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
        RouteState.inc(@non_error_resp_struct)
        RouteState.inc(@resp_struct)
      end

      assert {:ok, %{counter: counter}} = RouteState.state(@resp_struct)

      assert not Map.has_key?(counter, :fallback)
    end
  end

  test "exits when fetch_route_state_timeout reached" do
    assert catch_exit(RouteState.state(@resp_struct, 0)) ==
             {:timeout,
              {GenServer, :call,
               [{:via, Registry, {Belfrage.RouteStateRegistry, {Belfrage.RouteState, @route_state_id}}}, :state, 0]}}
  end

  defp start_route_state() do
    start_supervised!({RouteState, @route_state_id})
  end

  defp stop_route_state() do
    # TODO: Replace with stop_supervised! once we upgrade to Elixir 1.12.
    # stop_supervisor currently returns an error if the process that is stopped
    # is temporary, like the route_state process here.
    stop_supervised(RouteState)
  end

  defp set_env(name, value) do
    original_value = Application.get_env(:belfrage, name)
    Application.put_env(:belfrage, name, value)
    on_exit(fn -> Application.put_env(:belfrage, name, original_value) end)
  end
end
