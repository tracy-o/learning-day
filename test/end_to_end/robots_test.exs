defmodule EndToEnd.RobotsTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  alias BelfrageWeb.Router

  @moduletag :end_to_end

  test "returns the robots.txt file" do
    robots_content = File.read!("priv/static/robots.txt")
    response_conn = conn(:get, "/robots.txt") |> Router.call(routefile: Routes.Routefiles.Mock)

    assert {200,
            [
              {"cache-control", "max-age=30, public"}
            ], robots_content} == sent_resp(response_conn)
  end
end
