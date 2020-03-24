defmodule Belfrage.Cache.DistributedFallbackTest do
  use ExUnit.Case
  alias Belfrage.Struct
  alias Belfrage.Cache.DistributedFallback

  setup do
    Test.Support.FakeBelfrageCcp.start()

    :ok
  end

  test "store/1" do
    struct = %Struct{
      request: %Struct.Request{request_hash: "distributed-cache-test"},
      response: %Struct.Response{body: "<p>Hello</p>"}
    }

    DistributedFallback.store(struct)

    assert Test.Support.FakeBelfrageCcp.received_put?("distributed-cache-test", struct.response)
  end
end
