defmodule Belfrage.RequestTransformers.DevelopmentRequestsTest do
  use ExUnit.Case, async: true

  alias Belfrage.RequestTransformers.DevelopmentRequests
  alias Belfrage.Envelope

  test "when request has been replayed the ReplayedTraffic transformer is prepended" do
    envelope = %Envelope{request: %Envelope.Request{has_been_replayed?: true}}

    assert ["ReplayedTraffic"] == DevelopmentRequests.development_transformers(envelope)
  end

  test "when request has not been replayed the ReplayedTraffic transformer is not prepended" do
    envelope = %Envelope{request: %Envelope.Request{has_been_replayed?: nil}}

    assert [] == DevelopmentRequests.development_transformers(envelope)
  end

  test "return add: ReplayedTraffic updated transformer" do
    envelope = %Envelope{request: %Envelope.Request{has_been_replayed?: true}}

    assert {:ok, envelope, {:add, ["ReplayedTraffic"]}} == DevelopmentRequests.call(envelope)
  end
end
