defmodule Belfrage.CascadeTest do
  use ExUnit.Case, async: true

  alias Belfrage.Cascade
  alias Belfrage.Struct
  alias Belfrage.Struct.{Response, Private}

  describe "build/1" do
    test "builds a list of structs, one for each route spec" do
      struct = %Struct{private: %Private{loop_id: ~w(Loop1 Loop2)}}

      assert Cascade.build(struct) == [
               %Struct{private: %Private{loop_id: "Loop1", candidate_loop_ids: ~w(Loop1 Loop2)}},
               %Struct{private: %Private{loop_id: "Loop2", candidate_loop_ids: ~w(Loop1 Loop2)}}
             ]
    end

    test "returns a list with one struct if it doesn't need to be handled by the cascade" do
      struct = %Struct{private: %Private{loop_id: ~w(Loop)}}

      assert Cascade.build(struct) == [
               %Struct{private: %Private{loop_id: "Loop", candidate_loop_ids: ~w(Loop)}}
             ]
    end
  end

  describe "fan_out/2" do
    setup do
      cascade = [
        %Struct{private: %Private{loop_id: "Loop1"}},
        %Struct{private: %Private{loop_id: "Loop2"}}
      ]

      %{cascade: cascade}
    end

    test "executes the callback for each struct in the cascade asynchronously", %{cascade: cascade} do
      pid = self()

      {time, _} =
        :timer.tc(fn ->
          Cascade.fan_out(cascade, fn struct = %Struct{private: private = %Private{}} ->
            # Sleep for 10ms when processing each struct
            Process.sleep(10)
            send(pid, {:processed_struct_with_loop_id, private.loop_id})
            struct
          end)
        end)

      assert_received {:processed_struct_with_loop_id, "Loop1"}
      assert_received {:processed_struct_with_loop_id, "Loop2"}

      # Check that total execution time is less than 20ms, which proves that
      # the structs were processed asynchronously.
      assert time < 20_000
    end

    test "returns the struct with a response if there is one", %{cascade: cascade} do
      result =
        Cascade.fan_out(cascade, fn struct = %Struct{private: private = %Private{}} ->
          if private.loop_id == "Loop1" do
            Struct.add(struct, :response, %Response{http_status: 200})
          else
            struct
          end
        end)

      assert result == %Struct{response: %Response{http_status: 200}, private: %Private{loop_id: "Loop1"}}

      result =
        Cascade.fan_out(cascade, fn struct = %Struct{private: private = %Private{}} ->
          if private.loop_id == "Loop2" do
            Struct.add(struct, :response, %Response{http_status: 200})
          else
            struct
          end
        end)

      assert result == %Struct{response: %Response{http_status: 200}, private: %Private{loop_id: "Loop2"}}
    end

    test "returns the cascade if there are no structs with responses", %{cascade: cascade} do
      assert Cascade.fan_out(cascade, fn struct = %Struct{} -> struct end) == cascade
    end
  end

  describe "dispatch/1" do
    defmodule MockServiceProvider do
      @loop_responses %{
        "SuccessLoop" => 200,
        "404Loop" => 404
      }

      def dispatch(struct = %Struct{private: %Private{loop_id: loop_id}}) do
        send(self(), {:dispatched_struct_with_loop_id, loop_id})

        Struct.add(struct, :response, %Response{
          http_status: Map.fetch!(@loop_responses, loop_id),
          body: "Response for loop #{loop_id}"
        })
      end
    end

    test "does nothing when passed a struct" do
      struct = %Struct{private: %Private{loop_id: "Loop"}}
      assert Cascade.dispatch(struct) == struct
    end

    test "delegates to the appropriate service when passed a list with a single struct" do
      struct = %Struct{private: %Private{loop_id: "SuccessLoop"}}
      assert %Struct{response: response} = Cascade.dispatch([struct], MockServiceProvider)
      assert response.http_status == 200
      assert response.body == "Response for loop SuccessLoop"
    end

    test "sequentially requests services for each loop in the cascade" do
      cascade = [
        %Struct{private: %Private{loop_id: "404Loop"}},
        %Struct{private: %Private{loop_id: "SuccessLoop"}}
      ]

      assert %Struct{response: response} = Cascade.dispatch(cascade, MockServiceProvider)
      assert response.http_status == 200
      assert response.body == "Response for loop SuccessLoop"

      assert_received {:dispatched_struct_with_loop_id, "404Loop"}
      assert_received {:dispatched_struct_with_loop_id, "SuccessLoop"}
    end

    test "halts on first non-404 response from origins in the cascade" do
      cascade = [
        %Struct{private: %Private{loop_id: "SuccessLoop"}},
        %Struct{private: %Private{loop_id: "404Loop"}}
      ]

      assert %Struct{response: response} = Cascade.dispatch(cascade, MockServiceProvider)
      assert response.http_status == 200
      assert response.body == "Response for loop SuccessLoop"

      assert_received {:dispatched_struct_with_loop_id, "SuccessLoop"}
      refute_received {:dispatched_struct_with_loop_id, "404Loop"}
    end

    test "returns 404 response with empty body if all origins in cascade return 404" do
      cascade = [
        %Struct{private: %Private{loop_id: "404Loop"}},
        %Struct{private: %Private{loop_id: "404Loop"}}
      ]

      assert %Struct{response: response} = Cascade.dispatch(cascade, MockServiceProvider)
      assert response.http_status == 404
      assert response.body == ""
    end
  end
end
