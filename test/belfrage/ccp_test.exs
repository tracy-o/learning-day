defmodule Belfrage.CCPTest do
  use ExUnit.Case
  alias Belfrage.CCP
  alias Belfrage.{Struct, Struct.Request, Struct.Response}

  test "sends request and request hash as cast." do
    struct = %Struct{
      request: %Request{request_hash: "a-request-hash"},
      response: %Response{body: "<h1>Hi</h1>"}
    }

    assert :ok == CCP.put(struct, self())

    assert_receive({:"$gen_cast", {:put, "a-request-hash", %Response{body: "<h1>Hi</h1>"}}})
  end
end
