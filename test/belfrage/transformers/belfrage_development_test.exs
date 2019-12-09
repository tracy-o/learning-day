defmodule Belfrage.Transformers.DevelopmentRequestsTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Transformers.DevelopmentRequests
  alias Belfrage.Struct

  test "when request has been replayed" do
    struct = %Struct{request: %Struct.Request{has_been_replayed?: true}}

    assert ["ReplayedTraffic"] == DevelopmentRequests.development_transformers(struct)
  end

  test "when request has not been replayed" do
    struct = %Struct{request: %Struct.Request{has_been_replayed?: nil}}

    assert [] == DevelopmentRequests.development_transformers(struct)
  end

  test "when request is on a www subdomain" do
    struct = %Struct{request: %Struct.Request{subdomain: "www"}}

    assert [] == DevelopmentRequests.development_transformers(struct)
  end

  test "when request is not on a www subdomain" do
    struct = %Struct{request: %Struct.Request{subdomain: "my-commit-hash"}}

    assert ["PreviewLambda"] == DevelopmentRequests.development_transformers(struct)
  end

  describe "conflicting requests" do
    test "when request is not on a www subdomain, but is replayed" do
      struct = %Struct{request: %Struct.Request{subdomain: "my-commit-hash", has_been_replayed?: true}}

      assert ["ReplayedTraffic"] == DevelopmentRequests.development_transformers(struct)
    end
  end
end
