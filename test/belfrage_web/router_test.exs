defmodule BelfrageWeb.RouterTest do
  use ExUnit.Case
  use Plug.Test

  use Test.Support.Helper, :mox

  alias BelfrageWeb.Router

  describe "OPTIONS" do
    Enum.each(["/wc-data", "/wc-data/container", "/wc-data/p/container"], fn path ->
      test "will return a 204 for #{path}" do
        conn = conn(:options, unquote(path))
        conn = Router.call(conn, [])

        assert conn.status == 204

        assert conn.resp_headers == [
                 {"cache-control", "max-age=60, public"},
                 {"access-control-allow-methods", "GET, OPTIONS"},
                 {"access-control-allow-origin", "*"}
               ]

        assert conn.resp_body == ""
      end
    end)

    test "will return a 405" do
      conn = conn(:options, "/")
      conn = Router.call(conn, [])

      assert conn.status == 405
      assert conn.resp_body == ""
    end
  end

  describe "GET /status" do
    test "will return 'OK'" do
      conn = conn(:get, "/status")
      conn = Router.call(conn, [])

      assert conn.status == 200
      assert conn.resp_body == "I'm ok thanks"
    end
  end

  describe "handle_errors" do
    test "will set the status as 404 when the plug status code is 400" do
      reason = %{message: "Some error", plug_status: 400}
      conn = conn(:get, "/%")
      conn = Router.handle_errors(conn, %{kind: "err", reason: reason, stack: %{}})

      assert conn.status == 404
    end

    test "will set the status as 500 when the plug status code is not a 400" do
      reason = %{message: "Some error", plug_status: 500}
      conn = conn(:get, "/")
      conn = Router.handle_errors(conn, %{kind: "err", reason: reason, stack: %{}})

      assert conn.status == 500
    end
  end
end
