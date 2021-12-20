defmodule Belfrage.CascadeTest do
  use ExUnit.Case, async: true

  alias Belfrage.Cascade
  alias Belfrage.Struct
  alias Belfrage.Struct.{Response, Private}

  describe "build/1" do
    test "builds a list of structs, one for each route spec" do
      struct = %Struct{private: %Private{route_state_id: ~w(RouteState1 RouteState2)}}

      assert Cascade.build(struct) == %Cascade{
               items: [
                 %Struct{private: %Private{route_state_id: "RouteState1", candidate_route_state_ids: ~w(RouteState1 RouteState2)}},
                 %Struct{private: %Private{route_state_id: "RouteState2", candidate_route_state_ids: ~w(RouteState1 RouteState2)}}
               ]
             }
    end

    test "returns a list with one struct if it doesn't need to be handled by the cascade" do
      struct = %Struct{private: %Private{route_state_id: ~w(RouteState)}}

      assert Cascade.build(struct) == %Cascade{
               items: [
                 %Struct{private: %Private{route_state_id: "RouteState", candidate_route_state_ids: ~w(RouteState)}}
               ]
             }
    end
  end

  describe "fan_out/2" do
    setup do
      %{
        cascade: %Cascade{
          items: [
            %Struct{private: %Private{route_state_id: "RouteState1"}},
            %Struct{private: %Private{route_state_id: "RouteState2"}}
          ]
        }
      }
    end

    test "executes the callback for each struct in the cascade asynchronously", %{cascade: cascade} do
      pid = self()

      {time, _} =
        :timer.tc(fn ->
          Cascade.fan_out(cascade, fn struct = %Struct{private: private = %Private{}} ->
            # Sleep for 10ms when processing each struct
            Process.sleep(10)
            send(pid, {:processed_struct_with_route_state_id, private.route_state_id})
            struct
          end)
        end)

      assert_received {:processed_struct_with_route_state_id, "RouteState1"}
      assert_received {:processed_struct_with_route_state_id, "RouteState2"}

      # Check that total execution time is less than 20ms, which proves that
      # the structs were processed asynchronously.
      assert time < 20_000
    end

    test "returns the struct with a response if there is one", %{cascade: cascade} do
      %Cascade{result: result} =
        Cascade.fan_out(cascade, fn struct = %Struct{private: private = %Private{}} ->
          if private.route_state_id == "RouteState1" do
            Struct.add(struct, :response, %Response{http_status: 200})
          else
            struct
          end
        end)

      assert result == %Struct{response: %Response{http_status: 200}, private: %Private{route_state_id: "RouteState1"}}

      %Cascade{result: result} =
        Cascade.fan_out(cascade, fn struct = %Struct{private: private = %Private{}} ->
          if private.route_state_id == "RouteState2" do
            Struct.add(struct, :response, %Response{http_status: 200})
          else
            struct
          end
        end)

      assert result == %Struct{response: %Response{http_status: 200}, private: %Private{route_state_id: "RouteState2"}}
    end

    test "returns the cascade if there are no structs with responses", %{cascade: cascade} do
      assert Cascade.fan_out(cascade, fn struct = %Struct{} -> struct end) == cascade
    end
  end

  describe "dispatch/1" do
    defmodule MockServiceProvider do
      @route_state_responses %{
        "SuccessRouteState" => 200,
        "404RouteState" => 404
      }

      def dispatch(struct = %Struct{private: %Private{route_state_id: route_state_id}}) do
        send(self(), {:dispatched_struct_with_route_state_id, route_state_id})

        Struct.add(struct, :response, %Response{
          http_status: Map.fetch!(@route_state_responses, route_state_id),
          body: "Response for route_state #{route_state_id}"
        })
      end
    end

    test "sequentially requests services for each route_state in the cascade" do
      cascade = %Cascade{
        items: [
          %Struct{private: %Private{route_state_id: "404RouteState"}},
          %Struct{private: %Private{route_state_id: "SuccessRouteState"}}
        ]
      }

      assert %Struct{response: response} = Cascade.dispatch(cascade, MockServiceProvider)
      assert response.http_status == 200
      assert response.body == "Response for route_state SuccessRouteState"

      assert_received {:dispatched_struct_with_route_state_id, "404RouteState"}
      assert_received {:dispatched_struct_with_route_state_id, "SuccessRouteState"}
    end

    test "halts on first non-404 response from origins in the cascade" do
      cascade = %Cascade{
        items: [
          %Struct{private: %Private{route_state_id: "SuccessRouteState"}},
          %Struct{private: %Private{route_state_id: "404RouteState"}}
        ]
      }

      assert %Struct{response: response} = Cascade.dispatch(cascade, MockServiceProvider)
      assert response.http_status == 200
      assert response.body == "Response for route_state SuccessRouteState"

      assert_received {:dispatched_struct_with_route_state_id, "SuccessRouteState"}
      refute_received {:dispatched_struct_with_route_state_id, "404RouteState"}
    end

    test "returns 404 response with empty body if all origins in cascade return 404" do
      cascade = %Cascade{
        items: [
          %Struct{private: %Private{route_state_id: "404RouteState"}},
          %Struct{private: %Private{route_state_id: "404RouteState"}}
        ]
      }

      assert %Struct{response: response} = Cascade.dispatch(cascade, MockServiceProvider)
      assert response.http_status == 404
      assert response.body == ""
    end

    test "returns received 404 response body if there's only one origin in cascade" do
      cascade = %Cascade{
        items: [
          %Struct{private: %Private{route_state_id: "404RouteState"}}
        ]
      }

      assert %Struct{response: response} = Cascade.dispatch(cascade, MockServiceProvider)
      assert response.http_status == 404
      assert response.body == "Response for route_state 404RouteState"
    end
  end
end
