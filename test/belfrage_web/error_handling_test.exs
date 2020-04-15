defmodule BelfrageWeb.ErrorHandlingTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox

  alias BelfrageWeb.Router

  describe "Belfrage raising an exception" do
    test "Responds with 500 status code" do
      BelfrageMock
      |> expect(:handle, fn _struct ->
        raise("Something broke")
      end)

      conn = conn(:get, "/_web_core")

      assert_raise Plug.Conn.WrapperError, "** (RuntimeError) Something broke", fn ->
        Router.call(conn, [])
      end

      assert_received {:plug_conn, :sent}
      assert {500, _headers, "<h1>500 Error Page</h1>\n<!-- Belfrage -->"} = sent_resp(conn)
    end
  end
end
