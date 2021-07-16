defmodule EndToEnd.StubbedOriginSessionTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  import Belfrage.Test.PersonalisationHelper

  alias BelfrageWeb.Router

  @moduletag :end_to_end

  test "when no token provided" do
    response_conn = conn(:get, "/my/session") |> Router.call([])

    assert {200, resp_headers, resp_body} = sent_resp(response_conn)
    assert {"cache-control", "private, stale-if-error=90, stale-while-revalidate=30"} in resp_headers
    assert %{"authenticated" => false, "session_token" => nil, "valid_session" => false} == Jason.decode!(resp_body)
  end

  test "valid access and identity token" do
    response_conn =
      conn(:get, "/my/session")
      |> Map.put(:host, "www.bbc.co.uk")
      |> personalise_request()
      |> Router.call([])

    assert {200, resp_headers, resp_body} = sent_resp(response_conn)
    assert {"cache-control", "private, stale-if-error=90, stale-while-revalidate=30"} in resp_headers

    assert %{"authenticated" => true, "session_token" => "Provided", "valid_session" => true} ==
             Jason.decode!(resp_body)
  end

  # TODO Add tests for the un-happy path tests here (ticket RESFRAME-3873).
end
