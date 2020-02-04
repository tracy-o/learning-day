defmodule ContentEncodingTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  use Test.Support.Helper, :mox
  import Test.Support.Helper, only: [assert_gzipped: 2]

  @moduletag :end_to_end

  test "when the client accepts gzip the response should be gzipped" do
    Belfrage.Clients.HTTPMock
    |> expect(:execute, fn %Belfrage.Clients.HTTP.Request{} ->
      {:ok,
       %Belfrage.Clients.HTTP.Response{
         status_code: 200,
         body: :zlib.gzip("<p>gzipped content</p>"),
         headers: %{"content-encoding" => "gzip"}
       }}
    end)

    conn = conn(:get, "/_proxy_pass") |> put_req_header("accept-encoding", "gzip, deflate, br")
    conn = Router.call(conn, [])

    assert {200, headers, compressed_body} = sent_resp(conn)
    assert {"content-encoding", "gzip"} in headers
    assert_gzipped(compressed_body, "<p>gzipped content</p>")
  end

  test "when client does not accept gzip" do
    Belfrage.Clients.HTTPMock
    |> expect(:execute, fn %Belfrage.Clients.HTTP.Request{} ->
      {:ok,
       %Belfrage.Clients.HTTP.Response{
         status_code: 200,
         body: :zlib.gzip("<p>content</p>"),
         headers: %{"content-encoding" => "gzip"}
       }}
    end)

    conn = conn(:get, "/_proxy_pass") |> put_req_header("accept-encoding", "deflate, br")
    conn = Router.call(conn, [])

    assert {200, headers, "<p>content</p>"} = sent_resp(conn)
    assert [] == Plug.Conn.get_req_header(conn, "content-encoding")
  end

  test "when no accept-encoding header is sent" do
    Belfrage.Clients.HTTPMock
    |> expect(:execute, fn %Belfrage.Clients.HTTP.Request{} ->
      {:ok,
       %Belfrage.Clients.HTTP.Response{
         status_code: 200,
         body: :zlib.gzip("<p>content</p>"),
         headers: %{"content-encoding" => "gzip"}
       }}
    end)

    conn = conn(:get, "/_proxy_pass")
    conn = Router.call(conn, [])

    assert {200, headers, "<p>content</p>"} = sent_resp(conn)
    assert [] == Plug.Conn.get_req_header(conn, "content-encoding")
  end
end
