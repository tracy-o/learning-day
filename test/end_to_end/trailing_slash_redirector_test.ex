defmodule EndToEndTest.TrailingSlashRedirectorTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  use Test.Support.Helper, :mox

  @moduletag :end_to_end

  test "a succesful redirect if there is multiple trailing slashes at the top level" do
    conn =
      conn(:get, "///")
      |> Map.put(:request_path, "///")
      |> put_req_header("accept-encoding", "gzip")
      |> Router.call([])

    assert {301, headers, ""} = sent_resp(conn)
    assert {"location", "/"} in headers
  end

  test "a succesful redirect if there is a trailing slash" do
    conn =
      conn(:get, "/200-ok-response///")
      |> put_req_header("accept-encoding", "gzip")
      |> Router.call([])

    assert {301, headers, ""} = sent_resp(conn)
    assert {"location", "/200-ok-response"} in headers
    assert {"cache-control", "public, stale-if-error=90, stale-while-revalidate=30, max-age=60"} in headers
  end

  test "keeps default response headers" do
    conn =
      conn(:get, "/200-ok-response///")
      |> put_req_header("req-svc-chain", "GTM")
      |> put_req_header("accept-encoding", "gzip")
      |> Router.call([])

    assert {301, headers, ""} = sent_resp(conn)
    assert {"server", "Belfrage"} in headers
    assert {"via", "1.1 Belfrage"} in headers
    assert {"vary", "Accept-Encoding,X-BBC-Edge-Cache,X-Country,X-IP_Is_UK_Combined,X-BBC-Edge-Scheme"} in headers
  end

  test "keeps req-svc-chain values when provided" do
    conn =
      conn(:get, "/200-ok-response///")
      |> put_req_header("req-svc-chain", "GTM")
      |> put_req_header("accept-encoding", "gzip")
      |> Router.call([])

    assert {301, headers, ""} = sent_resp(conn)
    assert {"req-svc-chain", "GTM,BELFRAGE"} in headers
  end
end
