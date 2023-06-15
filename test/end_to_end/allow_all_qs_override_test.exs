defmodule AllowAllQsOverrideTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  alias Belfrage.RouteSpecManager
  use Test.Support.Helper, :mox

  import Test.Support.Helper, only: [set_environment: 1]

  @moduletag :end_to_end

  @http_response %Belfrage.Clients.HTTP.Response{
    status_code: 200,
    body: "some stuff from mozart",
    headers: %{}
  }

  setup do
    :ets.delete_all_objects(:cache)
    :ok
  end

  # The Moz route spec only allows one query string, but on test the Mozart platform allows a number of query strings
  test "Allow all query strings for Mozart platform routes on test" do
    RouteSpecManager.update_specs()

    url = Application.get_env(:belfrage, :mozart_news_endpoint) <> "/moz?country=gb&only_allow_this_on_live=123"

    Belfrage.Clients.HTTPMock
    |> expect(:execute, fn %Belfrage.Clients.HTTP.Request{
                             method: :get,
                             url: ^url
                           },
                           :MozartNews ->
      {:ok, @http_response}
    end)

    conn = conn(:get, "/moz?country=gb&b=foo&only_allow_this_on_live=123")
    conn = Router.call(conn, routefile: Routes.Routefiles.Mock)

    assert {200, _headers, _body} = sent_resp(conn)
  end

  test "Don't allow all query string for the Mozart platform routes on Live" do
    set_environment("live")
    RouteSpecManager.update_specs()

    url = Application.get_env(:belfrage, :mozart_news_endpoint) <> "/moz?only_allow_this_on_live=123"

    Belfrage.Clients.HTTPMock
    |> expect(:execute, fn %Belfrage.Clients.HTTP.Request{
                             method: :get,
                             url: ^url
                           },
                           :MozartNews ->
      {:ok, @http_response}
    end)

    conn = conn(:get, "/moz?a=bar&b=foo&only_allow_this_on_live=123")
    conn = Router.call(conn, routefile: Routes.Routefiles.Mock)

    assert {200, _headers, _body} = sent_resp(conn)
  end
end
