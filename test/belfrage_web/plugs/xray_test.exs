defmodule BelfrageWeb.Plugs.XRayTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox

  alias BelfrageWeb.Plugs

  test "creates a new trace" do
    Belfrage.XrayMock
    |> expect(:new_trace, fn ->
      Belfrage.XrayStub.new_trace()
    end)

    conn(:get, "/")
    |> Plugs.XRay.call([])
  end

  test "starts tracing" do
    Belfrage.XrayMock
    |> expect(
      :start_tracing,
      fn trace = %AwsExRay.Trace{
           root: "1-5dd274e2-00644696c03ec16a784a2e43"
         },
         "Belfrage" ->
        Belfrage.XrayStub.start_tracing(trace, "Belfrage")
      end
    )

    conn(:get, "/")
    |> Plugs.XRay.call([])
  end

  test "adds the request method and path" do
    Belfrage.XrayMock
    |> expect(:set_http_request, fn segment, %{method: "GET", path: "/"} ->
      segment
    end)

    conn(:get, "/")
    |> Plugs.XRay.call([])
  end

  test "when request is sampled, it sets xray trace ID, with 'Sampled' to 1" do
    conn = conn(:get, "/")
    conn = Plugs.XRay.call(conn, [])

    assert %Plug.Conn{
             private: %{xray_trace_id: "Root=1-5dd274e2-00644696c03ec16a784a2e43;Parent=fake-xray-parent-id;Sampled=1"}
           } = conn
  end

  test "when request is not sampled, it sets xray trace ID, with 'Sampled' to 0" do
    Belfrage.XrayMock
    |> expect(:sampled?, fn _segment -> false end)

    conn = conn(:get, "/")
    conn = Plugs.XRay.call(conn, [])

    assert %Plug.Conn{
             private: %{xray_trace_id: "Root=1-5dd274e2-00644696c03ec16a784a2e43;Parent=fake-xray-parent-id;Sampled=0"}
           } = conn
  end

  test "registers a before_send callback that finishes tracing" do
    Belfrage.XrayMock
    |> expect(
      :finish_tracing,
      fn _trace = %AwsExRay.Segment{
           trace: %AwsExRay.Trace{
             root: "1-5dd274e2-00644696c03ec16a784a2e43"
           }
         } ->
        :ok
      end
    )

    conn = conn(:get, "/")
    conn = Plugs.XRay.call(conn, [])

    assert length(conn.before_send) == 1

    callback =
      conn.before_send
      |> List.first()

    callback.(conn)
  end

  describe "adds response information in plug callback" do
    test "when content-length response header is given" do
      Belfrage.XrayMock
      |> expect(:set_http_response, fn segment, %{status: _status, content_length: "34758435"} ->
        segment
      end)

      conn =
        conn(:get, "/")
        |> Plug.Conn.put_resp_header("content-length", "34758435")
        |> Plugs.XRay.call([])

      callback =
        conn.before_send
        |> List.first()

      callback.(conn)
    end

    test "when content-length response header is not set" do
      Belfrage.XrayMock
      |> expect(:set_http_response, fn segment, %{status: _status, content_length: "not-reporting"} ->
        segment
      end)

      conn =
        conn(:get, "/")
        |> Plugs.XRay.call([])

      callback =
        conn.before_send
        |> List.first()

      callback.(conn)
    end
  end

  test "skips status route" do
    Belfrage.XrayMock
    |> expect(:new_trace, 0, fn ->
      raise "Should not be called"
    end)

    conn(:get, "/status")
    |> Plugs.XRay.call([])
  end
end
