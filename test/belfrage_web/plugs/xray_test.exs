defmodule BelfrageWeb.Plugs.XrayTest do
  use ExUnit.Case, async: true
  use Plug.Test
  use Test.Support.Helper, :mox
  use Belfrage.Test.XrayHelper

  alias BelfrageWeb.Plugs
  alias AwsExRay.Record.HTTPRequest

  describe "call/2 when tracing and no existing 'x-amzn-trace-id' header" do
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

  describe "call/2 when 'x-amzn-trace-id' header exists" do
    setup do
      root = "1-623c0289-148af71fcd58836604a286a5"
      parent = "9d27b4c4bd4b7140"
      sampled = "0"
      xray_header = "Root=#{root};Parent=#{parent};Sampled=#{sampled}"

      conn =
        conn(:get, "/some/route")
        |> Plug.Conn.put_req_header("x-amzn-trace-id", xray_header)
        |> Plugs.RequestId.call([])
        |> Plugs.Xray.call(xray: MockXray)

      %{conn: conn, root: root, parent: parent, sampled: sampled}
    end

    test "Root value in header is the same as trace root in the segment", %{conn: conn, root: root} do
      assert conn.assigns[:xray_segment].trace.root == root
    end

    test "the header has the same 'Parent' as the id of the current segment", %{conn: conn, parent: parent} do
      assert conn.assigns[:xray_segment].trace.parent == parent
    end

    test "'Sampled' value in the segment is the same as the header", %{conn: conn, sampled: expected_sample} do
      sample =
        if conn.assigns[:xray_segment].trace.sampled do
          "1"
        else
          "0"
        end

      assert sample == expected_sample
    end
  end

  describe "call/2 when 'x-amzn-trace-id' is malformed, starts new trace" do
    setup do
      root = "1-623c0289-148af71fcd58836604a286a5"
      parent = "9d27b4c4bd4b7140"
      # this being the part which malforms the header
      sampled = "A"
      xray_header = "Root=#{root};Parent=#{parent};Sampled=#{sampled}"

      conn =
        conn(:get, "/some/route")
        |> Plug.Conn.put_req_header("x-amzn-trace-id", xray_header)
        |> Plugs.RequestId.call([])
        |> Plugs.Xray.call(xray: MockXray)

      %{conn: conn, root: root, parent: parent, sampled: sampled}
    end

    test "the root is different", %{conn: conn, root: root} do
      assert conn.assigns[:xray_segment].trace.root != root
    end

    test "the parent is empty", %{conn: conn} do
      assert conn.assigns[:xray_segment].trace.parent == ""
    end

    test "the sample is a true or false", %{conn: conn} do
      assert is_boolean(conn.assigns[:xray_segment].trace.sampled)
    end
  end
end
