defmodule BelfrageWeb.Plugs.AccessLogsTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox

  alias Belfrage.Struct
  alias BelfrageWeb.Plugs
  import ExUnit.CaptureLog

  test "registers a callback for access log" do
    conn = conn(:get, "/")
    conn = Plugs.AccessLogs.call(conn, [])

    assert length(conn.before_send) == 1
  end

  test "the registered callback returns a %Plug.Conn{}" do
    conn = conn(:get, "/")
    conn = Plugs.AccessLogs.call(conn, [])

    callback =
      conn.before_send
      |> List.first()

    assert %Plug.Conn{} = callback.(conn)
  end

  test "the registered callback logs" do
    BelfrageMock
    |> expect(:handle, fn struct ->
      Struct.add(struct, :response, %{
        body: "",
        headers: %{"access-log-res-header" => "yes", "ssl" => "ssl-value", "set-cookie" => "session=12345"},
        http_status: 200
      })
    end)

    captured_log =
      capture_log(fn ->
        conn(:get, "/a-req-path") |> put_req_header("access-log-req-header", "yes") |> BelfrageWeb.Router.call([])
      end)

    assert captured_log =~ "/a-req-path", "Failed to log request path"
    assert captured_log =~ "200", "Failed to log response status code"
    assert captured_log =~ "GET", "Failed to log request method"
    assert captured_log =~ "access-log-res-header", "Failed to log response headers"
    assert captured_log =~ "access-log-req-header", "Failed to log request headers"
    assert captured_log =~ "set-cookie", "Should keep header keys relating to cookies"
    assert captured_log =~ "ssl", "Should keep header keys relating to SSL"
    assert count_words(captured_log, "REDACTED") == 2, "Failed to replace cookie and ssl values from header"
    refute captured_log =~ "session=12345", "Cookie value still present in log"
    refute captured_log =~ "ssl-value", "SSL value still present in log"
  end

  defp count_words(string, word) do
    Regex.scan(~r/#{word}/i, string) |> length()
  end
end
