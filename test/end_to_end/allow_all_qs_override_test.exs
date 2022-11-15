defmodule AllowAllQsOverrideTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  alias Belfrage.RouteState
  use Test.Support.Helper, :mox

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

  # The Moz.ex route spec only allows one query string, but on test the mozart platform allows all query strings
  test "Allow all query strings for Mozart platform routes on test" do
    start_supervised!({RouteState, "Moz"})

    url = Application.get_env(:belfrage, :mozart_news_endpoint) <> "/moz?a=bar&b=foo"

    Belfrage.Clients.HTTPMock
    |> expect(:execute, fn %Belfrage.Clients.HTTP.Request{
                             method: :get,
                             url: ^url
                           },
                           :MozartNews ->
      {:ok, @http_response}
    end)

    conn = conn(:get, "/moz?a=bar&b=foo")
    conn = Router.call(conn, [])

    assert {200, _headers, _body} = sent_resp(conn)
  end

  test "Don't allow all query string for the Mozart platform routes on Live" do
    original_env = Application.get_env(:belfrage, :production_environment)
    Application.put_env(:belfrage, :production_environment, "live")

    start_supervised!({RouteState, "Moz"})

    on_exit(fn ->
      Application.put_env(:belfrage, :production_environment, original_env)
    end)

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
    conn = Router.call(conn, [])

    assert {200, _headers, _body} = sent_resp(conn)
  end
end
