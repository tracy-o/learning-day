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

    conn = conn(:get, "/")
    conn = Plugs.XRay.call(conn, [])
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

    conn = conn(:get, "/")
    conn = Plugs.XRay.call(conn, [])
  end

  test "registers a before_send callback that finishes tracing" do
    Belfrage.XrayMock
    |> expect(
      :finish_tracing,
      fn trace = %AwsExRay.Segment{
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

  test "skips status route" do
    Belfrage.XrayMock
    |> expect(:new_trace, 0, fn ->
      raise "Should not be called"
    end)

    conn = conn(:get, "/status")
    conn = Plugs.XRay.call(conn, [])
  end
end
