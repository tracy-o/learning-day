defmodule EndToEnd.RssTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  alias Belfrage.Clients.{HTTP, HTTPMock}
  alias Belfrage.RouteState
  use Test.Support.Helper, :mox

  describe "On error if returning from FABL" do
    setup do
      # start_supervised!({RouteState, "SomeClassicAppsRouteSpec"})
      :ets.delete_all_objects(:cache)
      :ok
    end

    test "Response body is changed to an empty string " do
      fabl_endpoint = Application.get_env(:belfrage, :fabl_endpoint)

      url = "#{fabl_endpoint}/fd/rss?guid=9f2b27b0-641f-4d9a-a400-b9db34e9cdea"

      expect(HTTPMock, :execute, 1, fn %HTTP.Request{url: ^url}, _pool ->
        {:ok,
         %HTTP.Response{
           headers: %{
             "cache-control" => "public, max-age=30"
           },
           status_code: 500,
           body: "Error from FABL"
         }}
      end)

      conn =
        conn(
          :get,
          "https://feeds.bbci.co.uk/sport/rugby-union/teams/munster/rss.xml"
        )
        |> Router.call([])

      IO.inspect(conn)
      assert conn.resp_body == "<h1>404 Page Not Found</h1>\n<!-- Belfrage -->"
      assert conn.resp_headers["content-length"] == 23
    end
  end
end
