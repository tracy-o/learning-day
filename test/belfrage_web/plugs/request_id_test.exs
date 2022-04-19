defmodule BelfrageWeb.Plugs.RequestIdTest do
  use ExUnit.Case
  import Plug.Test, only: [conn: 2]

  test "generates and sets request ID to the logger metadata" do
    conn = conn(:get, "/")
    assert %Plug.Conn{private: %{request_id: request_id}} = BelfrageWeb.Plugs.RequestId.call(conn, _opts = [])
    assert String.length(request_id) > 30

    assert [request_id: request_id] == Logger.metadata()
  end
end
