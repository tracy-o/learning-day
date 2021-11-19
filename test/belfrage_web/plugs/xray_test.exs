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
        |> Plugs.Xray.call(xray_client: SampleXray)

      %{conn: conn}
    end

    test "skips status route" do
      conn =
        conn(:get, "/status")
        |> Plugs.RequestId.call([])

      assert conn == Plugs.Xray.call(conn, [])
    end

    test "puts the segment into the conn", %{conn: conn} do
      assert conn.private[:xray_segment]
    end

    test "segment has annotations", %{conn: conn} do
      assert %{request_id: _} = conn.private[:xray_segment].annotation
    end

    test "segment has http request set", %{conn: conn} do
      request = conn.private[:xray_segment].http.request

      assert request == %HTTPRequest{
               segment_type: :segment,
               method: "GET",
               url: "/some/route"
             }
    end

    test "registers a before_send callback", %{conn: conn} do
      assert length(conn.before_send) == 1
    end

    test "when response had been sent, finishes tracing", %{conn: conn} do
      conn =
        conn
        |> resp(200, "OK")
        |> send_resp()

      assert conn.private[:xray_segment].end_time > 0
    end

    test "when response had been sent, sends message to client", %{conn: conn} do
      conn
      |> resp(200, "OK")
      |> send_resp()

      assert_received {:client_mock, data}
      json = Jason.decode!(data)
      assert json["trace_id"]
      assert json["name"] == "Belfrage"
    end
  end

  describe "call/2 when no tracing is occuring" do
    setup do
      conn =
        conn(:get, "/some/route")
        |> Plugs.RequestId.call([])
        |> Plugs.Xray.call(xray_client: IgnoreXray)

      %{conn: conn}
    end

    test "puts segment into the conn", %{conn: conn} do
      assert conn.private[:xray_segment]
    end

    test "segment has no annotations", %{conn: conn} do
      assert %{} == conn.private[:xray_segment].annotation
    end

    test "segment has no http request set", %{conn: conn} do
      request = conn.private[:xray_segment].http.request

      assert request == nil
    end

    test "when response had been sent, doesn't finish tracing", %{conn: conn} do
      conn =
        conn
        |> resp(200, "OK")
        |> send_resp()

      assert conn.private[:xray_segment].end_time == 0
    end

    test "when response had been sent, doesn't send message to client", %{conn: conn} do
      conn
      |> resp(200, "OK")
      |> send_resp()

      refute_received {:client_mock, _data}
    end
  end
end
