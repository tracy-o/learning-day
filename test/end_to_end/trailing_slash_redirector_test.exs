defmodule EndToEndTest.TrailingSlashRedirectorTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  alias Belfrage.RouteState
  use Test.Support.Helper, :mox
  import Test.Support.Helper, only: [build_request_uri: 1]

  @moduletag :end_to_end

  setup do
    start_supervised!({RouteState, "SomeRouteState"})
    :ok
  end

  test "a succesful redirect if there is multiple trailing slashes at the top level" do
    conn =
      conn(:get, build_request_uri(path: "///"))
      |> Map.put(:request_path, "///")
      |> Router.call([])

    assert {301, headers, ""} = sent_resp(conn)
    assert {"location", "/"} in headers
  end

  test "a succesful redirect if there is a trailing slash" do
    conn = conn(:get, build_request_uri(path: "/200-ok-response///"))
    conn = Router.call(conn, [])

    assert {301, headers, ""} = sent_resp(conn)
    assert {"location", "/200-ok-response"} in headers
    assert {"cache-control", "public, max-age=60"} in headers
  end

  test "keeps default response headers" do
    conn =
      conn(:get, build_request_uri(path: "/200-ok-response///"))
      |> put_req_header("req-svc-chain", "GTM")
      |> Router.call([])

    assert {301, headers, ""} = sent_resp(conn)
    assert {"server", "Belfrage"} in headers
    assert {"via", "1.1 Belfrage"} in headers
    assert {"x-bbc-no-scheme-rewrite", "1"} in headers
  end

  test "keeps req-svc-chain values when provided" do
    conn =
      conn(:get, build_request_uri(path: "/200-ok-response///"))
      |> put_req_header("req-svc-chain", "GTM")
      |> Router.call([])

    assert {301, headers, ""} = sent_resp(conn)
    assert {"req-svc-chain", "GTM,BELFRAGE"} in headers
  end
end
