defmodule Belfrage.Transformers.ReplayedTrafficTest do
  use ExUnit.Case

  alias Belfrage.Transformers.ReplayedTraffic
  alias Belfrage.Struct

  @replayed_request_struct %Struct{
    request: %Struct.Request{has_been_replayed?: true, path: "/_web_core"},
    private: %Struct.Private{
      origin: "an-origin-set-by-the-route_state",
      platform: SomePlatform,
      pipeline: ["ReplayedTraffic"]
    }
  }

  @non_replayed_request_struct Struct.add(@replayed_request_struct, :request, %{
                                 has_been_replayed?: nil
                               })

  test "non-replayed traffic will be unaffected" do
    assert {
             :ok,
             %Struct{
               private: %Struct.Private{
                 origin: "an-origin-set-by-the-route_state",
                 platform: SomePlatform
               }
             }
           } = ReplayedTraffic.call([], @non_replayed_request_struct)
  end

  test "replayed traffic will be sent to a different origin" do
    assert {
             :ok,
             %Belfrage.Struct{
               private: %Belfrage.Struct.Private{
                 origin: "http://origin.bbc.com",
                 platform: OriginSimulator
               }
             }
           } = ReplayedTraffic.call([], @replayed_request_struct)
  end
end
