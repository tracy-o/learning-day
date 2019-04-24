defmodule IngressWeb.RequestHeaders.HandlerTest do
  use ExUnit.Case
  use Plug.Test

  alias IngressWeb.RequestHeaders.Handler

  describe "call" do
    test "sets BBC headers in the conn" do
      conn = conn("get", "/", "") |> put_req_header("x-bbc-edge-country", "gb")

      assert Handler.call(conn, []).private == %{
               bbc_headers: %{cache: false, country: "gb", host: nil}
             }
    end
  end
end
