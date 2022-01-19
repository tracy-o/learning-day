defmodule BelfrageWeb.Plugs.XrayTest do
  use ExUnit.Case, async: true
  use Plug.Test
  use Test.Support.Helper, :mox
  use Belfrage.Test.XrayHelper

  alias BelfrageWeb.Plugs
  alias AwsExRay.Record.HTTPRequest

  describe "call/2 when tracing" do
    setup do
      conn =
        conn(:get, "/some/route")
        |> Plugs.RequestId.call([])
        |> Plugs.Xray.call(xray: MockXray)

      %{conn: conn}
    end

    test "skips status route" do
      conn =
        conn(:get, "/status")
        |> Plugs.RequestId.call([])

      assert Plugs.Xray.call(conn, []) == conn
    end

    test "puts the segment into the conn", %{conn: conn} do
      assert conn.assigns[:xray_segment]
    end

    test "segment has annotations", %{conn: conn} do
      assert %{request_id: _} = conn.assigns[:xray_segment].annotation
    end

    test "segment has http request set", %{conn: conn} do
      request = conn.assigns[:xray_segment].http.request

      assert request == %HTTPRequest{
               segment_type: :segment,
               method: "GET",
               url: "/some/route"
             }
    end

    test "when response had been sent, finishes tracing", %{conn: conn} do
      conn =
        conn
        |> resp(200, "OK")
        |> send_resp()

      assert conn.assigns[:xray_segment].end_time > 0
    end

    test "when response had been sent, sends message to client", %{conn: conn} do
      conn
      |> resp(200, "OK")
      |> send_resp()

      assert_received {:mock_xray_client_data, data}
      json = Jason.decode!(data)
      assert json["trace_id"]
      assert json["name"] == "Belfrage"
    end
  end
end
