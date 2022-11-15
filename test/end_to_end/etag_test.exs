defmodule EndToEnd.EtagTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox

  alias BelfrageWeb.Router
  alias Belfrage.Clients.{HTTP, HTTPMock}

  @http_response %HTTP.Response{
    status_code: 200,
    body: "",
    headers: %{}
  }

  @etag ~s("da39a3ee5e6b4b0d3255bfef95601890afd80709")

  setup :expect_http_response

  describe "when etags are supported" do
    test ~s(and a matching "if-none-match" request header is present, etag is added to response) do
      conn =
        conn(:get, "/etag-support")
        |> put_req_header("if-none-match", @etag)
        |> Router.call([])

      assert [@etag] == get_resp_header(conn, "etag")
      assert {200, _headers, _body} = sent_resp(conn)
    end

    test ~s(and a non-matching "if-none-match" request header is present, etag is added to response) do
      conn =
        conn(:get, "/etag-support")
        |> put_req_header("if-none-match", ~s("something"))
        |> Router.call([])

      assert [@etag] == get_resp_header(conn, "etag")
      assert {200, _headers, _body} = sent_resp(conn)
    end

    test ~s(and no "if-none-match" request header is present, etag is added to response) do
      conn =
        conn(:get, "/etag-support")
        |> Router.call([])

      assert [@etag] == get_resp_header(conn, "etag")
      assert {200, _headers, _body} = sent_resp(conn)
    end
  end

  describe "when etags are not supported" do
    test ~s(and a "matching" "if-none-match" request header is present, etag is not added to response) do
      conn =
        conn(:get, "/no-etag-support")
        |> put_req_header("if-none-match", @etag)
        |> Router.call([])

      assert [] == get_resp_header(conn, "etag")
      assert {200, _headers, _body} = sent_resp(conn)
    end

    test ~s(and a "non-matching" "if-none-match" request header is present, etag is not added to response) do
      conn =
        conn(:get, "/no-etag-support")
        |> put_req_header("if-none-match", ~s("something"))
        |> Router.call([])

      assert [] == get_resp_header(conn, "etag")
      assert {200, _headers, _body} = sent_resp(conn)
    end

    test ~s(and no "if-none-match" request header is present, etag is not added to response) do
      conn =
        conn(:get, "/no-etag-support")
        |> Router.call([])

      assert [] == get_resp_header(conn, "etag")
      assert {200, _headers, _body} = sent_resp(conn)
    end
  end

  defp expect_http_response(_context) do
    expect(HTTPMock, :execute, 1, fn _request, _origin ->
      {:ok, @http_response}
    end)

    :ok
  end
end
