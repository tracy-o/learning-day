defmodule BelfrageWeb.ErrorHandlingTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox

  alias BelfrageWeb.Router

  describe "erroneous web core route" do
    test "Responds with 500 status code" do
      BelfrageMock
      |> expect(:handle, fn _ ->
        raise("Something broke")
      end)

      conn = conn(:get, "/_web_core")

      assert_raise Plug.Conn.WrapperError, "** (RuntimeError) Something broke", fn ->
        Router.call(conn, [])
      end

      assert_received {:plug_conn, :sent}
      assert {500, _headers, "500 Internal Server Error"} = sent_resp(conn)
    end
  end
end
