defmodule Belfrage.RouteStateTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox
  import Belfrage.Test.RoutingHelper
  import Process, only: [send: 3]

  alias Belfrage.{Struct, RouteState, RouteSpec, RouteStateRegistry}

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
    {:ok, pid: start_route_state()}
  end

  test "returns a state pointer" do
    route_spec =
      @route_state_id
      |> String.to_atom()
      |> RouteSpec.specs_for()
      |> Map.from_struct()

    assert RouteState.state(@legacy_request_struct) ==
             {:ok, Map.merge(route_spec, %{route_state_id: @route_state_id, counter: %{}})}
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
    # Set the interval just for this specifc test
    interval = 100
    set_env(:short_counter_reset_interval, interval)

    for _ <- 1..30, do: RouteState.inc(@resp_struct)
    {:ok, state} = RouteState.state(@legacy_request_struct)
    assert state.counter.errors == 30

    Process.sleep(interval + 1)

    {:ok, state} = RouteState.state(@legacy_request_struct)
    assert false == Map.has_key?(state.counter, :error), "RouteState should have reset"
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

  test ":throughput value is initialised as expected" do
    pid =
      RouteStateRegistry.find_or_start(%Struct{
        private: %Struct.Private{route_state_id: @route_state_id}
      })

    assert match?(%{throughput: 100}, :sys.get_state(pid))
  end

  describe ":throughput value is updated in the state as expected" do
    test "when the error count exceeeds threshold", %{pid: pid} do
      replace_throughput(pid, 60)

      replace_counts(pid, "pwa-lambda-function", %{501 => 300, :errors => 300})

      send(pid, :reset, [])

      assert match?(%{throughput: 0}, :sys.get_state(pid))
    end

    test "when the error count does not exceeed threshold and throughput is at maximum", %{pid: pid} do
      replace_throughput(pid, 100)

      replace_counts(pid, "pwa-lambda-function", %{501 => 100, :errors => 100})

      send(pid, :reset, [])

      assert match?(%{throughput: 100}, :sys.get_state(pid))
    end

    test "when the error count does not exceeed threshold and throughput is not at maximum", %{pid: pid} do
      replace_throughput(pid, 0)

      replace_counts(pid, "pwa-lambda-function", %{501 => 100, :errors => 100})

      send(pid, :reset, [])

      assert match?(%{throughput: 20}, :sys.get_state(pid))

      send(pid, :reset, [])

      assert match?(%{throughput: 60}, :sys.get_state(pid))

      send(pid, :reset, [])

      assert match?(%{throughput: 100}, :sys.get_state(pid))
    end
  end

  defp replace_throughput(pid, throughput) do
    :sys.replace_state(pid, fn state ->
      %{state | throughput: throughput}
    end)
  end

  defp replace_counts(pid, origin, counts) do
    :sys.replace_state(pid, fn state ->
      %{state | counter: %{origin => counts}}
    end)
  end

  defp start_route_state() do
    start_supervised!({RouteState, @route_state_id})
  end

  defp set_env(name, value) do
    original_value = Application.get_env(:belfrage, name)
    Application.put_env(:belfrage, name, value)
    on_exit(fn -> Application.put_env(:belfrage, name, original_value) end)
  end
end
