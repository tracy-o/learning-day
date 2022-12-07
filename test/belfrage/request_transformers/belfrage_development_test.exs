defmodule Belfrage.RequestTransformers.DevelopmentRequestsTest do
  use ExUnit.Case, async: true

  alias Belfrage.RequestTransformers.DevelopmentRequests
  alias Belfrage.Struct

  test "when request has been replayed the ReplayedTraffic transformer is prepended" do
    struct = %Struct{request: %Struct.Request{has_been_replayed?: true}}

    assert ["ReplayedTraffic"] == DevelopmentRequests.development_transformers(struct)
  end

  test "when request has not been replayed the ReplayedTraffic transformer is not prepended" do
    struct = %Struct{request: %Struct.Request{has_been_replayed?: nil}}

    assert [] == DevelopmentRequests.development_transformers(struct)
  end

  test "return add: ReplayedTraffic updated transformer" do
    struct = %Struct{request: %Struct.Request{has_been_replayed?: true}}

    assert {:ok, struct, {:add, ["ReplayedTraffic"]}} == DevelopmentRequests.call(struct)
  end
end
