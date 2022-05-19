defmodule Belfrage.Mvt.StateTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  import Test.Support.Helper, only: [set_env: 2]

  alias Belfrage.{Mvt, RouteState}
  alias Belfrage.Struct.Response

  describe "get_vary_headers/1" do
    test "gets single mvt vary header" do
      ["mvt-button-colour"] =
        Mvt.State.get_vary_headers(%Response{
          headers: %{
            "vary" => "something,mvt-button-colour,something-else"
          }
        })
    end

    test "gets multiple mvt vary headers" do
      ["mvt-button-colour", "mvt-sidebar-colour"] =
        Mvt.State.get_vary_headers(%Response{
          headers: %{
            "vary" => "something,mvt-button-colour,something-else,mvt-sidebar-colour"
          }
        })
    end

    test "returns empty list when no mvt vary headers present" do
      [] =
        Mvt.State.get_vary_headers(%Response{
          headers: %{
            "vary" => "something,something-else"
          }
        })
    end

    test "returns empty list when no vary header present" do
      [] =
        Mvt.State.get_vary_headers(%Response{
          headers: %{}
        })
    end
  end

  describe "filter_mvt_headers/2" do
    test "drops all bbc-mvt- headers when no route state can be found" do
      assert %{"foo" => "bar"} ==
               Mvt.State.filter_mvt_headers(
                 %{"foo" => "bar", "bbc-mvt-1" => "some;header;value"},
                 "some_route_state_id"
               )
    end

    test "drops all bbc-mvt- headers when call to route state timeouts" do
      defmodule TestRouteState do
        use GenServer

        def start_link(name) do
          GenServer.start_link(__MODULE__, nil,
            name: {:via, Registry, {Belfrage.RouteStateRegistry, {Belfrage.RouteState, name}}}
          )
        end

        @impl GenServer
        def init(_) do
          {:ok, nil}
        end

        @impl GenServer
        def handle_call(:state, _from, state) do
          Process.sleep(100)
          {:reply, {:ok, state}, state}
        end
      end

      set_env(:fetch_route_state_timeout, 10)

      start_supervised!({TestRouteState, "SomeTestRouteState"})

      assert %{"foo" => "bar"} ==
               Mvt.State.filter_mvt_headers(
                 %{
                   "foo" => "bar",
                   "bbc-mvt-1" => "some;button_colour;value",
                   "bbc-mvt-2" => "some;sidebar_colour;value"
                 },
                 "SomeTestRouteState"
               )
    end

    test "drops all bbc-mvt- headers that are not in :mvt_seen in RouteState state" do
      now = DateTime.utc_now()
      pid = start_supervised!({RouteState, "SomeRouteState"})

      :sys.replace_state(pid, fn state ->
        Map.put(state, :mvt_seen, %{"mvt-button_colour" => now})
      end)

      assert %{"foo" => "bar", "bbc-mvt-1" => "some;button_colour;value"} ==
               Mvt.State.filter_mvt_headers(
                 %{
                   "foo" => "bar",
                   "bbc-mvt-1" => "some;button_colour;value",
                   "bbc-mvt-2" => "some;sidebar_colour;value"
                 },
                 "SomeRouteState"
               )
    end

    test "drops all bbc-mvt- headers that have values not in the correct format" do
      pid = start_supervised!({RouteState, "SomeRouteState"})

      :sys.replace_state(pid, fn state ->
        Map.put(state, :mvt_seen, %{
          "mvt-button_colour" => DateTime.utc_now(),
          "mvt-footer_colour" => DateTime.utc_now(),
          "mvt-banner_colour" => DateTime.utc_now()
        })
      end)

      assert %{"foo" => "bar", "bbc-mvt-1" => "some;button_colour;value"} ==
               Mvt.State.filter_mvt_headers(
                 %{
                   "foo" => "bar",
                   "bbc-mvt-1" => "some;button_colour;value",
                   "bbc-mvt-2" => "some;footer_colour;value;something_else",
                   "bbc-mvt-3" => "some;banner_colour"
                 },
                 "SomeRouteState"
               )
    end
  end
end
