defmodule Belfrage.Cache.DistributedTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Struct
  alias Belfrage.Cache.Distributed

  test "store/1" do
    struct = %Struct{
      request: %Struct.Request{request_hash: "distributed-cache-test"},
      response: %Struct.Response{body: "<p>Hello</p>"}
    }

    Belfrage.Clients.CCPMock
    |> expect(:put, fn ^struct -> :ok end)

    Distributed.store(struct)
  end
end
