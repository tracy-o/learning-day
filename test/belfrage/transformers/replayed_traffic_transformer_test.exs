defmodule Belfrage.Transformers.ReplayedTrafficTransformerTest do
  use ExUnit.Case

  alias Belfrage.Transformers.ReplayedTrafficTransformer
  alias Test.Support.StructHelper
  alias Belfrage.Struct

  @replayed_request_struct StructHelper.build(
                             request: %{has_been_replayed?: true},
                             private: %{
                               origin: "an-origin-set-by-the-loop",
                               pipeline: ["ReplayedTrafficTransformer"]
                             }
                           )

  @non_replayed_request_struct Struct.add(@replayed_request_struct, :request, %{
                                 has_been_replayed?: nil
                               })

  test "non-replayed traffic will be unaffected" do
    assert {
             :ok,
             %Struct{
               private: %Struct.Private{
                 origin: "an-origin-set-by-the-loop"
               }
             }
           } = ReplayedTrafficTransformer.call([], @non_replayed_request_struct)
  end

  test "replayed traffic will be sent to a different origin" do
    http_origin = Application.get_env(:belfrage, :origin)

    assert {
             :ok,
             %Belfrage.Struct{
               private: %Belfrage.Struct.Private{
                 origin: ^http_origin
               }
             }
           } = ReplayedTrafficTransformer.call([], @replayed_request_struct)
  end
end
