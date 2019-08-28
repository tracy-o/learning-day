defmodule BelfrageWeb.RouterTest do
  use ExUnit.Case
  use Plug.Test

  alias BelfrageWeb.Router

  describe "OPTIONS" do
    test "will return a 406" do
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
end
