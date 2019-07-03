defmodule BelfrageWeb.RouterTest do
  use ExUnit.Case
  use Plug.Test

  alias BelfrageWeb.Router

  describe "GET /status" do
    test "will return 'OK'" do
      conn = conn(:get, "/status")
      conn = Router.call(conn, [])

      assert conn.status == 200
      assert conn.resp_body == "I'm ok thanks"
    end
  end

  describe "Page not found" do
    test "will return a 'Not Found' message" do
      conn = conn(:get, "/foobar")
      conn = Router.call(conn, [])

      assert conn.status == 404
      assert get_resp_header(conn, "content-type") == ["text/plain; charset=utf-8"]
      assert conn.resp_body == "404 Not Found"
    end
  end
end
