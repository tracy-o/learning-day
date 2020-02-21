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
              {"cache-control", "max-age=60, public, must-revalidate"},
              {"location", "http://www.example.com/200-ok-response"},
              {"content-type", "text/plain; charset=utf-8"}
            ], "Redirecting"} == sent_resp(conn)
  end
end
