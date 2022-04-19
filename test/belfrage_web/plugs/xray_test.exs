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

  # a `x-amzn-trace-id` header look like they're from an xray instrmented
  # application if they have at least Root,Sampled keys go to 'Tracing Header'
  # for more detail:
  # https://docs.aws.amazon.com/xray/latest/devguide/xray-concepts.html
  describe "call/2 when 'x-amzn-trace-id' looks like its from an X-Ray Instrumented application" do
    test "arbitrary key-value pairs are kept in the header" do
      root = "1-623c0289-148af71fcd58836604a286a5"
      parent = "9d27b4c4bd4b7140"
      sampled = "0"
      xray_header = "Root=#{root};Parent=#{parent};Sampled=#{sampled};ArbitraryKey=ArbitraryValue"

      conn = make_request_with([["x-amzn-trace-id", xray_header]])

      header_parts =
        Belfrage.Xray.build_trace_id_header(conn.assigns[:xray_segment])
        |> split_header()

      assert [
        ["Root", "1-623c0289-148af71fcd58836604a286a5"],
        ["Parent", _],
        ["Sampled", _],
        ["ArbitraryKey", "ArbitraryValue"]
      ] = header_parts
    end

    test "the header comes straight from a client, xray header is parsed" do
      root = "1-623c0289-148af71fcd58836604a286a5"
      parent = "9d27b4c4bd4b7140"
      sampled = "0"
      xray_header = "Root=#{root};Parent=#{parent};Sampled=#{sampled}"

      conn = make_request_with([["x-amzn-trace-id", xray_header]])

      assert conn.assigns[:xray_segment].trace.root == root
    end

    # 'direct client' here means that the 'req-svc-chain' doesn't exist. This
    # means the request is either us using a direct endpoint (e.g.
    # bruce.belfrage.test.api.bbc.co.uk/) or a local development request.
    test "the request doesn't come from Belfrage or a direct client, new xray header is created" do
      root = "1-623c0289-148af71fcd58836604a286a5"
      parent = "9d27b4c4bd4b7140"
      sampled = "0"
      xray_header = "Root=#{root};Parent=#{parent};Sampled=#{sampled}"

      conn =
        make_request_with([
          ["x-amzn-trace-id", xray_header],
          ["req-svc-chain", "FASTLY,GTM"]
        ])

      assert conn.assigns[:xray_segment].trace.root != root
    end

    test "the request comes from belfrage, xray header is parsed" do
      root = "1-623c0289-148af71fcd58836604a286a5"
      parent = "9d27b4c4bd4b7140"
      sampled = "0"
      xray_header = "Root=#{root};Parent=#{parent};Sampled=#{sampled}"

      conn =
        make_request_with([
          ["x-amzn-trace-id", xray_header],
          ["req-svc-chain", "BELFRAGE"]
        ])

      assert conn.assigns[:xray_segment].trace.root == root
    end
  end

  describe "call/2 when 'x-amzn-trace-id' is a partial trace header" do
    test "arbitrary key-value pairs are kept in the header" do
      root = "1-623c0289-148af71fcd58836604a286a5"
      xray_header = "Root=#{root};ArbitraryKey=ArbitraryValue"

      conn = make_request_with([["x-amzn-trace-id", xray_header]])

      header_parts =
        Belfrage.Xray.build_trace_id_header(conn.assigns[:xray_segment])
        |> split_header()

      assert [
        ["Root", "1-623c0289-148af71fcd58836604a286a5"],
        ["Parent", _],
        ["Sampled", _],
        ["ArbitraryKey", "ArbitraryValue"]
      ] = header_parts


    end

    test "a `Sample` key is added to the header" do
      root = "1-623c0289-148af71fcd58836604a286a5"
      xray_header = "Root=#{root}"

      conn = make_request_with([["x-amzn-trace-id", xray_header]])
      sampled = conn.assigns[:xray_segment].trace.sampled

      assert sampled == true or sampled == false
    end

    test "if a `Self` key exists its removed" do
      self = "1-67891234-12456789abcdef012345678"
      root = "1-623c0289-148af71fcd58836604a286a5"
      xray_header = "Self=#{self};Root=#{root}"

      conn = make_request_with([["x-amzn-trace-id", xray_header]])

      refute conn.assigns[:xray_segment].metadata[:extra_trace_data]
    end

    test "the request comes straight from a client, header is parsed" do
      root = "1-623c0289-148af71fcd58836604a286a5"
      xray_header = "Root=#{root}"

      conn = make_request_with([["x-amzn-trace-id", xray_header]])

      assert conn.assigns[:xray_segment].trace.root == root
    end

    test "the request doesn't come from belfrage or client but is < 200 chars, header is parsed" do
      root = "1-623c0289-148af71fcd58836604a286a5"
      short_value = "ShortValue"
      xray_header = "Root=#{root};Short=#{short_value}"

      conn = make_request_with([["x-amzn-trace-id", xray_header], ["req-svc-chain", "FASTLY,GTM"]])

      assert conn.assigns[:xray_segment].trace.root == root
    end

    test "the request doesn't come from belfrage or client but is >= 200 chars, start new trace" do
      root = "1-623c0289-148af71fcd58836604a286a5"
      long_value = String.duplicate("a", 200)
      xray_header = "Root=#{root};Long=#{long_value}"

      conn = make_request_with([["x-amzn-trace-id", xray_header], ["req-svc-chain", "FASTLY,GTM"]])

      assert conn.assigns[:xray_segment].trace.root != root
    end

    test "the request comes from belfrage, header is parsed" do
      root = "1-623c0289-148af71fcd58836604a286a5"
      xray_header = "Root=#{root};Parent=segment-id;Sample=0"

      conn = make_request_with([["x-amzn-trace-id", xray_header], ["req-svc-chain", "BELFRAGE"]])

      assert conn.assigns[:xray_segment].trace.root == root
    end
  end

  describe "call/2 when 'x-amzn-trace-id' is malformed, starts new trace" do
    setup do
      root = "1-623c0289-148af71fcd58836604a286a5"
      parent = "9d27b4c4bd4b7140"
      # this being the part which malforms the header
      sampled = "A"
      xray_header = "Root=#{root};Parent=#{parent};Sampled=#{sampled}"

      conn = make_request_with([["x-amzn-trace-id", xray_header]])

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

  defp split_header(header) do
    header
    |> String.split(";")
    |> Enum.map(&String.split(&1, "="))
  end

  defp make_request_with(headers) do
    conn = conn(:get, "/some/route")

    Enum.reduce(headers, conn, fn [k, v], conn -> Plug.Conn.put_req_header(conn, k, v) end)
    |> Plugs.RequestId.call([])
    |> Plugs.Xray.call(xray: MockXray)
  end
end
