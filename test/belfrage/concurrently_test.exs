defmodule Belfrage.ConcurrentlyTest do
  use ExUnit.Case
  alias Belfrage.{Concurrently, Struct}

  defp to_stream(list), do: Stream.map(list, & &1)

  describe "starting a new concurrent task with multiple %Belfrage.Struct{}" do
    test "returns a stream" do
      struct = %Struct{private: %Struct.Private{loop_id: "SomeLoop"}}
      result = Concurrently.start(struct)

      assert result.__struct__ == Stream, "Concurrently.start/1 should return a stream"
    end

    test "when given a struct with loop_id as string" do
      struct = %Struct{private: %Struct.Private{loop_id: "SomeLoop"}}
      result_as_list = struct |> Concurrently.start() |> Enum.to_list()

      assert result_as_list == [%Struct{private: %Struct.Private{loop_id: "SomeLoop", all_loop_ids: ["SomeLoop"]}}]
    end

    test "when given a struct with a list of strings for loop_id value, order is maintained" do
      struct = %Struct{private: %Struct.Private{loop_id: ["SomeLoop", "AnotherLoop", "ThirdLoop"]}}
      result_as_list = struct |> Concurrently.start() |> Enum.to_list()

      assert result_as_list == [
               %Struct{
                 private: %Struct.Private{loop_id: "SomeLoop", all_loop_ids: ["SomeLoop", "AnotherLoop", "ThirdLoop"]}
               },
               %Struct{
                 private: %Struct.Private{
                   loop_id: "AnotherLoop",
                   all_loop_ids: ["SomeLoop", "AnotherLoop", "ThirdLoop"]
                 }
               },
               %Struct{
                 private: %Struct.Private{loop_id: "ThirdLoop", all_loop_ids: ["SomeLoop", "AnotherLoop", "ThirdLoop"]}
               }
             ]
    end
  end

  describe "running a callback in a stream" do
    @structs [
      %Struct{private: %Struct.Private{loop_id: "SomeLoop", platform: :one}},
      %Struct{private: %Struct.Private{loop_id: "AnotherLoop", platform: :two}},
      %Struct{private: %Struct.Private{loop_id: "ThirdLoop", platform: :three}}
    ]

    test "the callback returns results in the same order" do
      struct_stream = to_stream(@structs)

      assert ["SomeLoop", "AnotherLoop", "ThirdLoop"] ==
               Concurrently.run(struct_stream, & &1.private.loop_id)
    end
  end

  describe "picks struct which contains an early response" do
    test "accepts a stream, and evaluates it to return a list" do
      struct_stream = to_stream(@structs)
      assert @structs == Concurrently.pick_early_response(struct_stream)
    end

    test "when 0 structs have an early response, struct order is maintained" do
      assert @structs == Concurrently.pick_early_response(@structs)
    end

    test "when struct stream contains a 200 response, we return only that struct" do
      struct_with_response = %Struct{
        private: %Struct.Private{loop_id: "InjectedLoop"},
        response: %Struct.Response{http_status: 200}
      }

      structs = List.insert_at(@structs, 1, struct_with_response) |> to_stream()

      assert struct_with_response == Concurrently.pick_early_response(structs)
    end

    test "when struct stream contains a redirect response, we return only that struct" do
      struct_with_response = %Struct{
        private: %Struct.Private{loop_id: "InjectedLoop"},
        response: %Struct.Response{http_status: 302}
      }

      structs = List.insert_at(@structs, 1, struct_with_response) |> to_stream()

      assert struct_with_response == Concurrently.pick_early_response(structs)
    end

    test "2 responses found in stream of structs" do
      first_struct_with_response = %Struct{
        private: %Struct.Private{loop_id: "InjectedLoop"},
        response: %Struct.Response{http_status: 200}
      }

      second_struct_with_response = %Struct{
        private: %Struct.Private{loop_id: "SecondInjectedLoop"},
        response: %Struct.Response{http_status: 302}
      }

      structs = List.insert_at(@structs, 2, first_struct_with_response)
      structs = List.insert_at(structs, 3, second_struct_with_response) |> to_stream()

      assert first_struct_with_response == Concurrently.pick_early_response(structs)
    end
  end

  describe "random_dedup_platform/1" do
    test "accepts and returns a stream" do
      struct_stream = to_stream(@structs)
      result = Concurrently.random_dedup_platform(struct_stream)

      assert result.__struct__ == Stream
    end

    test "when every struct has a different platform, the same list is returned" do
      struct_stream = to_stream(@structs)
      assert @structs == Concurrently.random_dedup_platform(struct_stream) |> Enum.to_list()
    end

    test "when a struct shares a platform, the list returned is de-duped by platform" do
      second_struct_for_platform_one = %Struct{
        private: %Struct.Private{loop_id: "AnotherPlatformTwoLoop", platform: :one}
      }

      structs = [second_struct_for_platform_one | @structs]

      struct_stream = to_stream(structs)

      assert [
               %Struct{private: %Struct.Private{platform: :one}},
               %Struct{private: %Struct.Private{platform: :two}},
               %Struct{private: %Struct.Private{platform: :three}}
             ] = Concurrently.random_dedup_platform(struct_stream) |> Enum.to_list()
    end
  end
end
