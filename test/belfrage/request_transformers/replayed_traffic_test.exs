defmodule Belfrage.RequestTransformers.ReplayedTrafficTest do
  use ExUnit.Case

  alias Belfrage.RequestTransformers.ReplayedTraffic
  alias Belfrage.Envelope

  @replayed_request_envelope %Envelope{
    request: %Envelope.Request{has_been_replayed?: true, path: "/_web_core"},
    private: %Envelope.Private{
      origin: "an-origin-set-by-the-route_state",
      platform: "SomePlatform",
      request_pipeline: ["ReplayedTraffic"]
    }
  }

  @non_replayed_request_envelope Envelope.add(@replayed_request_envelope, :request, %{
                                   has_been_replayed?: nil
                                 })

  test "non-replayed traffic will be unaffected" do
    assert {
             :ok,
             %Envelope{
               private: %Envelope.Private{
                 origin: "an-origin-set-by-the-route_state",
                 platform: "SomePlatform"
               }
             }
           } = ReplayedTraffic.call(@non_replayed_request_envelope)
  end

  test "replayed traffic will be sent to a different origin" do
    assert {
             :ok,
             %Belfrage.Envelope{
               private: %Belfrage.Envelope.Private{
                 origin: "http://origin.bbc.com",
                 platform: "OriginSimulator"
               }
             }
           } = ReplayedTraffic.call(@replayed_request_envelope)
  end
end
