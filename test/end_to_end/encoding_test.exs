defmodule ContentEncodingTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  use Test.Support.Helper, :mox
  import Test.Support.Helper, only: [assert_gzipped: 2]

  @moduletag :end_to_end

  test "when the user accepts gzip" do
    Belfrage.Clients.HTTPMock
    |> expect(:execute, fn %Belfrage.Clients.HTTP.Request{
                             headers: %{},
                             method: :get,
                             payload: "",
                             timeout: _timeout,
                             url: _url
                           } ->
      {:ok,
       %Belfrage.Clients.HTTP.Response{
         status_code: 200,
         body: :zlib.gzip("<p>gzipped content</p>"),
         headers: %{"content-encoding" => "gzip"}
       }}
    end)

    conn = conn(:get, "/_proxy_pass") |> put_req_header("accept-encoding", "gzip, deflate, compression")
    conn = Router.call(conn, [])

    assert {200, headers, compressed_body} = sent_resp(conn)
    assert {"content-encoding", "gzip"} in headers
    assert_gzipped(compressed_body, "<p>gzipped content</p>")
  end
end
