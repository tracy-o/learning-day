defmodule EndToEnd.App.RouteTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  import Belfrage.Test.CachingHelper

  alias BelfrageWeb.Router
  alias Belfrage.{Clients.HTTPMock, Clients.HTTP, RouteState}

  @moduletag :end_to_end

  setup do
    clear_cache()
    start_supervised!({RouteState, "SomeClassicAppsRouteSpec"})
    :ok
  end

  @response {:ok,
             %HTTP.Response{
               status_code: 200,
               body: "<h1>Hello from and Apps Endpoint!</h1>",
               headers: %{}
             }}

  describe "When app request has valid host" do
    test "a request is send to an apps endpoint" do
      stub_origin_request(@response, 1)

      conn =
        conn(:get, "http://news-app-classic.test.api.bbci.co.uk/classic-apps-route")
        |> Router.call([])

      assert conn.assigns.struct.private.origin == Application.get_env(:belfrage, :trevor_endpoint)
    end
  end

  describe "When an app request has an invalid host" do
    test "the request is returned as a 400" do
      stub_origin_request(@response, 0)

      conn =
        conn(:get, "http://invalid-host.test.api.bbci.co.uk/classic-apps-route")
        |> Router.call([])

      assert {400, _headers, _body} = sent_resp(conn)
    end
  end

  defp stub_origin_request(response, times) do
    expect(HTTPMock, :execute, times, fn _request, _origin ->
      response
    end)
  end
end
