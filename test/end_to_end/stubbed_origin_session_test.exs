defmodule EndToEnd.StubbedOriginSessionTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  import Belfrage.Test.PersonalisationHelper
  import Test.Support.Helper, only: [build_request_uri: 1]

  alias BelfrageWeb.Router
  alias Belfrage.RouteState

  @moduletag :end_to_end

  setup do
    start_supervised!({RouteState, "MySession"})
    :ok
  end

  test "when no token provided" do
    response_conn = conn(:get, build_request_uri(path: "/my/session")) |> Router.call([])

    assert {200, resp_headers, resp_body} = sent_resp(response_conn)
    assert {"cache-control", "private, stale-if-error=90, stale-while-revalidate=30"} in resp_headers
    assert %{"authenticated" => false, "session_token" => nil, "valid_session" => false} == Jason.decode!(resp_body)
  end

  test "valid access and identity token" do
    response_conn =
      conn(:get, build_request_uri(path: "/my/session"))
      |> Map.put(:host, "https://www.bbc.co.uk")
      |> personalise_request()
      |> Router.call([])

    assert {200, resp_headers, resp_body} = sent_resp(response_conn)
    assert {"cache-control", "private, stale-if-error=90, stale-while-revalidate=30"} in resp_headers

    assert %{"authenticated" => true, "session_token" => "Provided", "valid_session" => true} ==
             Jason.decode!(resp_body)
  end

  # TODO Add tests for the un-happy path tests here (ticket RESFRAME-3873).
end
