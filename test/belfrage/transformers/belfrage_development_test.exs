defmodule Belfrage.Transformers.DevelopmentRequestsTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Transformers.DevelopmentRequests
  alias Belfrage.Struct

  test "when request has been replayed the ReplayedTraffic transformer is prepended" do
    struct = %Struct{request: %Struct.Request{has_been_replayed?: true}}

    assert ["ReplayedTraffic"] == DevelopmentRequests.development_transformers(struct)
  end

  test "when request has not been replayed the ReplayedTraffic transformer is not prepended" do
    struct = %Struct{request: %Struct.Request{has_been_replayed?: nil}}

    assert [] == DevelopmentRequests.development_transformers(struct)
  end
end
