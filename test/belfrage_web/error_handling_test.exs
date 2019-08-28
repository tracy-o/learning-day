defmodule BelfrageWeb.ErrorHandlingTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox

  alias BelfrageWeb.Router

  describe "Serving error pages" do
    test "responds with 404 status code" do
      BelfrageMock
      |> expect(:handle, fn _ ->
        raise("Something broke")
      end)

      conn = conn(:get, "/foo_bar")

      assert_raise Plug.Conn.WrapperError, "** (RuntimeError) Something broke", fn ->
        Router.call(conn, [])
      end

      assert_received {:plug_conn, :sent}
      assert {404, _headers, "404 Not Found"} = sent_resp(conn)
    end

    test "Responds with 500 status code" do
      BelfrageMock
      |> expect(:handle, fn _ ->
        raise("Something broke")
      end)

      conn = conn(:get, "/sport")

      assert_raise Plug.Conn.WrapperError, "** (RuntimeError) Something broke", fn ->
        Router.call(conn, [])
      end

      assert_received {:plug_conn, :sent}
      assert {500, _headers, "500 Internal Server Error"} = sent_resp(conn)
    end
  end
end
