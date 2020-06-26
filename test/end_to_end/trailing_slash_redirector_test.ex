defmodule EndToEndTest.TrailingSlashRedirectorTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  use Test.Support.Helper, :mox

  @moduletag :end_to_end

  test "a succesful redirect if there is a trailing slash" do
    conn = conn(:get, "/200-ok-response///")
    conn = Router.call(conn, [])

    assert {301,
            [
              {"cache-control", "public, max-age=60"},
              {"location", "/200-ok-response"},
              {"content-type", "text/html; charset=utf-8"},
              {"vary", "Accept-Encoding, X-BBC-Edge-Cache, X-IP_Is_UK_Combined, X-BBC-Edge-Scheme"},
              {"server", "Belfrage"},
              {"bid", "local"},
              {"via", "1.1 Belfrage"},
              {"req-svc-chain", "BELFRAGE"}
            ], ""} == sent_resp(conn)
  end
end
