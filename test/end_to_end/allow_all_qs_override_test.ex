defmodule AllowAllQsOverrideTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  use Test.Support.Helper, :mox

  @moduletag :end_to_end

  @http_response %Belfrage.Clients.HTTP.Response{
    status_code: 200,
    body: "some stuff from mozart",
    headers: %{}
  }

  setup do
    :ets.delete_all_objects(:cache)
    Belfrage.LoopsSupervisor.kill_all()
  end

  # The Moz.ex route spec only allows one query string, but on test the mozart platform allows all query strings
  test "Allow all query strings for Mozart platform routes on test" do
    Belfrage.Clients.HTTPMock
    |> expect(:execute, fn %Belfrage.Clients.HTTP.Request{
                             method: :get,
                             url: "https://www.mozart-routing.test.api.bbci.co.uk/moz?a=bar&b=foo"
                           },
                           :MozartNews ->
      {:ok, @http_response}
    end)

    conn = conn(:get, "/moz?a=bar&b=foo")
    conn = Router.call(conn, [])

    assert {200, _headers, _body} = sent_resp(conn)
  end

  test "Don't allow all query string for the Mozart platform routes on Live" do
    Application.put_env(:belfrage, :production_environment, "live")

    Belfrage.Clients.HTTPMock
    |> expect(:execute, fn %Belfrage.Clients.HTTP.Request{
                             method: :get,
                             url: "https://www.mozart-routing.test.api.bbci.co.uk/moz?only_allow_this_on_live=123"
                           },
                           :MozartNews ->
      {:ok, @http_response}
    end)

    conn = conn(:get, "/moz?a=bar&b=foo&only_allow_this_on_live=123")
    conn = Router.call(conn, [])

    assert {200, _headers, _body} = sent_resp(conn)

    Application.put_env(:belfrage, :production_environment, "test")
  end
end
