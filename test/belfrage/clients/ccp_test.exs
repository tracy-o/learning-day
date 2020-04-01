defmodule Belfrage.Clients.CCPTest do
  use ExUnit.Case
  alias Belfrage.Clients.CCP
  alias Belfrage.{Struct, Struct.Request, Struct.Response}

  setup do
    Test.Support.FakeBelfrageCcp.start()

    :ok
  end

  test "sends request and request hash as cast." do
    struct = %Struct{
      request: %Request{request_hash: "a-request-hash"},
      response: %Response{body: "<h1>Hi</h1>"}
    }

    assert :ok == CCP.put(struct)

    assert Test.Support.FakeBelfrageCcp.received_put?("a-request-hash", %Response{body: "<h1>Hi</h1>"})
  end
end
