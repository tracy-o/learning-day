defmodule Belfrage.RouteStateTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox
  import Belfrage.Test.RoutingHelper
  import Process, only: [send: 3]

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

  test "returns a state pointer" do
    start_supervised!({RouteState, @route_state_id})

    route_spec =
      @route_state_id
      |> String.to_atom()
      |> RouteSpec.specs_for()
      |> Map.from_struct()

    assert RouteState.state(@legacy_request_struct) ==
             {:ok, Map.merge(route_spec, %{route_state_id: @route_state_id, counter: %{}})}
  end

  describe "returns a different count per origin" do
    setup :start_route_state

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
    start_supervised!({RouteState, @route_state_id})

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
    setup :start_route_state

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
    start_supervised!({RouteState, @route_state_id})

    assert catch_exit(RouteState.state(@resp_struct, 0)) ==
             {:timeout,
              {GenServer, :call,
               [{:via, Registry, {Belfrage.RouteStateRegistry, {Belfrage.RouteState, @route_state_id}}}, :state, 0]}}
  end

  test ":throughput value is initialised as expected" do
    pid = start_supervised!({RouteState, @route_state_id})
    assert match?(%{throughput: 100}, :sys.get_state(pid))
  end

  describe ":throughput value is updated in the state as expected" do
    setup :start_route_state

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

  describe "update/1 only updates http status code" do
    setup :start_route_state

    test "when no vary header exists", %{
      pid: pid
    } do
      :erlang.trace(pid, true, [:receive])

      struct = %Struct{
        private: %Struct.Private{route_state_id: "RouteStateTestRouteSpec", origin: "https://some.origin"},
        response: %Struct.Response{
          http_status: 200,
          fallback: false,
          headers: %{}
        }
      }

      RouteState.update(struct)

      assert_receive {:trace, ^pid, :receive, {:"$gen_cast", {:inc, 200, "https://some.origin", false}}},
                     100

      assert %{mvt_seen: %{}, counter: %{"https://some.origin" => %{:errors => 0, 200 => 1}}} = :sys.get_state(pid)
    end

    test "when no MVT vary headers exist", %{
      pid: pid
    } do
      :erlang.trace(pid, true, [:receive])

      struct = %Struct{
        private: %Struct.Private{route_state_id: "RouteStateTestRouteSpec", origin: "https://some.origin"},
        response: %Struct.Response{
          http_status: 200,
          fallback: false,
          headers: %{"vary" => "something,something-else"}
        }
      }

      RouteState.update(struct)

      assert_receive {:trace, ^pid, :receive, {:"$gen_cast", {:inc, 200, "https://some.origin", false}}},
                     100

      assert %{mvt_seen: %{}, counter: %{"https://some.origin" => %{:errors => 0, 200 => 1}}} = :sys.get_state(pid)
    end

    test "when response is fallback", %{
      pid: pid
    } do
      :erlang.trace(pid, true, [:receive])

      struct = %Struct{
        private: %Struct.Private{route_state_id: "RouteStateTestRouteSpec", origin: "https://some.origin"},
        response: %Struct.Response{
          http_status: 200,
          fallback: true,
          headers: %{"vary" => "something,mvt-button-colour,something-else"}
        }
      }

      RouteState.update(struct)

      assert_receive {:trace, ^pid, :receive, {:"$gen_cast", {:inc, 200, "https://some.origin", true}}},
                     100
    end
  end

  describe "update/1 increments http status code counter when response is not fallback and MVT headers are in response, and updates :mvt_seen" do
    setup [:start_route_state, :update_mvt_seen_with_button_colour_header]

    test "with one header-datetime key-value pair when MVT vary header is in response",
         %{pid: pid, header_datetime: button_colour_datetime} do
      assert %{mvt_seen: mvt_seen, counter: %{"https://some.origin" => %{:errors => 0, 200 => 1}}} = :sys.get_state(pid)
      assert ["mvt-button-colour"] = Map.keys(mvt_seen)
      assert :gt == DateTime.compare(DateTime.utc_now(), button_colour_datetime)
    end

    test "with new datetime for existing header when the same MVT vary header is in response",
         %{pid: pid, header_datetime: orig_button_colour_datetime, struct: struct} do
      RouteState.update(struct)

      assert_receive {:trace, ^pid, :receive,
                      {:"$gen_cast", {:update, 200, "https://some.origin", ["mvt-button-colour"]}}},
                     100

      assert %{mvt_seen: mvt_seen, counter: %{"https://some.origin" => %{200 => 2, :errors => 0}}} = :sys.get_state(pid)
      assert ["mvt-button-colour"] = Map.keys(mvt_seen)
      new_button_colour_datetime = mvt_seen["mvt-button-colour"]

      assert :gt == DateTime.compare(DateTime.utc_now(), new_button_colour_datetime)
      assert :gt == DateTime.compare(new_button_colour_datetime, orig_button_colour_datetime)
    end

    test "with new header-datetime key-value pair when different MVT vary header is in response",
         %{pid: pid, header_datetime: button_colour_datetime, struct: struct} do
      RouteState.update(
        Struct.add(struct, :response, %{
          headers: %{"vary" => "something,mvt-sidebar-colour,something-else"}
        })
      )

      assert_receive {:trace, ^pid, :receive,
                      {:"$gen_cast", {:update, 200, "https://some.origin", ["mvt-sidebar-colour"]}}},
                     100

      assert %{
               mvt_seen: mvt_seen,
               counter: %{"https://some.origin" => %{200 => 2, :errors => 0}}
             } = :sys.get_state(pid)

      assert ["mvt-button-colour", "mvt-sidebar-colour"] = Map.keys(mvt_seen)
      sidebar_button_colour = mvt_seen["mvt-sidebar-colour"]

      assert :gt == DateTime.compare(DateTime.utc_now(), sidebar_button_colour)
      assert :gt == DateTime.compare(sidebar_button_colour, button_colour_datetime)
    end

    test "overrides existing header with new datetime, and adds new header-datetime key-value pair",
         %{pid: pid, header_datetime: orig_button_colour_datetime, struct: struct} do
      RouteState.update(
        Struct.add(struct, :response, %{
          headers: %{"vary" => "something,mvt-button-colour,something-else,mvt-footer-colour,"}
        })
      )

      assert_receive {:trace, ^pid, :receive,
                      {:"$gen_cast", {:update, 200, "https://some.origin", ["mvt-button-colour", "mvt-footer-colour"]}}},
                     100

      assert %{
               mvt_seen: mvt_seen,
               counter: %{"https://some.origin" => %{200 => 2, :errors => 0}}
             } = :sys.get_state(pid)

      assert ["mvt-button-colour", "mvt-footer-colour"] = Map.keys(mvt_seen)
      new_button_colour_datetime = mvt_seen["mvt-button-colour"]
      footer_colour_datetime = mvt_seen["mvt-footer-colour"]

      assert :gt == DateTime.compare(DateTime.utc_now(), footer_colour_datetime)
      assert :eq == DateTime.compare(footer_colour_datetime, new_button_colour_datetime)
      assert :gt == DateTime.compare(new_button_colour_datetime, orig_button_colour_datetime)
    end
  end

  describe ":mvt seen is pruned as expected" do
    setup [:set_ten_sec_mvt_vary_header_ttl, :set_ten_ms_route_state_reset_interval, :start_route_state]

    test "when some mvt vary headers have a timestamp older than the interval", %{pid: pid} do
      now = DateTime.utc_now()

      :sys.replace_state(pid, fn state ->
        Map.put(state, :mvt_seen, %{
          "mvt-one" => now,
          "mvt-two" => datetime_minus(now, 20, :second),
          "mvt-three" => datetime_minus(now, 500, :millisecond),
          "mvt-four" => datetime_minus(now, 300, :second),
          "mvt-five" => datetime_minus(now, 5, :second)
        })
      end)

      Process.sleep(20)

      assert %{mvt_seen: mvt_seen} = :sys.get_state(pid)
      assert ["mvt-five", "mvt-one", "mvt-three"] == Map.keys(mvt_seen)
    end
  end

  defp datetime_minus(datetime, amount, unit) do
    datetime |> DateTime.add(-amount, unit, Calendar.UTCOnlyTimeZoneDatabase)
  end

  defp set_ten_sec_mvt_vary_header_ttl(_context) do
    set_env(:mvt_vary_header_ttl, 10_000)
  end

  defp set_ten_ms_route_state_reset_interval(_context) do
    set_env(:route_state_reset_interval, 10)
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

  defp start_route_state(_context) do
    {:ok, pid: start_supervised!({RouteState, @route_state_id})}
  end

  defp set_env(name, value) do
    original_value = Application.get_env(:belfrage, name)
    Application.put_env(:belfrage, name, value)
    on_exit(fn -> Application.put_env(:belfrage, name, original_value) end)
  end

  defp update_mvt_seen_with_button_colour_header(context = %{pid: pid}) do
    :erlang.trace(pid, true, [:receive])

    struct = %Struct{
      private: %Struct.Private{route_state_id: "RouteStateTestRouteSpec", origin: "https://some.origin"},
      response: %Struct.Response{
        http_status: 200,
        fallback: false,
        headers: %{"vary" => "something,mvt-button-colour,something-else"}
      }
    }

    RouteState.update(struct)

    assert_receive {:trace, ^pid, :receive,
                    {:"$gen_cast", {:update, 200, "https://some.origin", ["mvt-button-colour"]}}},
                   100

    assert %{mvt_seen: mvt_seen} = :sys.get_state(pid)
    assert ["mvt-button-colour"] = Map.keys(mvt_seen)

    context =
      context
      |> Map.put(:header_datetime, mvt_seen["mvt-button-colour"])
      |> Map.put(:struct, struct)

    {:ok, context}
  end
end
