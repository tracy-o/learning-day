defmodule EndToEnd.ClassicAppTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  alias Belfrage.Clients.{HTTP, HTTPMock}
  alias Belfrage.RouteState
  use Test.Support.Helper, :mox

  describe "request is made to Trevor" do
    setup do
      start_supervised!({RouteState, {"SomeClassicAppsRouteSpec", "ClassicApps"}})
      :ets.delete_all_objects(:cache)
      :ok
    end

    test "successful response returns a 200 with cache control of same max age" do
      trevor_endpoint = Application.get_env(:belfrage, :trevor_endpoint)

      url = "#{trevor_endpoint}/classic-apps-route"

      expect(HTTPMock, :execute, 1, fn %HTTP.Request{url: ^url}, _pool ->
        {:ok,
         %HTTP.Response{
           headers: %{
             "cache-control" => "public, max-age=30"
           },
           status_code: 200,
           body: "OK from Trevor!"
         }}
      end)

      conn =
        conn(
          :get,
          "https://news-app-classic.test.api.bbci.co.uk/classic-apps-route"
        )
        |> Router.call([])

      assert ["public, stale-if-error=90, stale-while-revalidate=30, max-age=60"] =
               get_resp_header(conn, "cache-control")
    end

    test "not found response returns a 404 with a public cache control" do
      trevor_endpoint = Application.get_env(:belfrage, :trevor_endpoint)

      url = "#{trevor_endpoint}/classic-apps-route"

      expect(HTTPMock, :execute, 1, fn %HTTP.Request{url: ^url}, _pool ->
        {:ok,
         %HTTP.Response{
           headers: %{},
           status_code: 404,
           body: "Not found from Trevor!"
         }}
      end)

      conn =
        conn(
          :get,
          "https://news-app-classic.test.api.bbci.co.uk/classic-apps-route"
        )
        |> Router.call([])

      assert ["public, stale-if-error=90, stale-while-revalidate=60, max-age=60"] =
               get_resp_header(conn, "cache-control")
    end

    test "not found response returns a 404 with only varying on accept-encoding" do
      conn =
        conn(
          :get,
          "https://news-app-classic.test.api.bbci.co.uk/classic-apps-route-will-404-as-no-match"
        )
        |> put_req_header("x-bbc-edge-cdn", "1")
        |> Router.call([])

      assert ["Accept-Encoding"] = get_resp_header(conn, "vary")
    end
  end
end
