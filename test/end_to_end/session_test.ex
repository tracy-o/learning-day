defmodule EndToEnd.SessionTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  alias BelfrageWeb.Router

  @moduletag :end_to_end

  setup do
    %{
      valid_access_token: Fixtures.AuthToken.valid_access_token()
    }
  end

  test "when no token provided" do
    response_conn = conn(:get, "/my/session") |> Router.call([])

    assert {200, resp_headers, resp_body} = sent_resp(response_conn)
    assert {"cache-control", "private, stale-if-error=90, stale-while-revalidate=30"} in resp_headers
    assert %{"authenticated" => false, "session_token" => nil, "valid_session" => false} == Jason.decode!(resp_body)
  end

  test "valid access and identity token", %{
    valid_access_token: access_token
  } do
    response_conn =
      conn(:get, "/my/session")
      |> put_req_header("cookie", "ckns_atkn=#{access_token};x-id-oidc-signedin=yes")
      |> Router.call([])

    assert {200, resp_headers, resp_body} = sent_resp(response_conn)
    assert {"cache-control", "private, stale-if-error=90, stale-while-revalidate=30"} in resp_headers

    assert %{"authenticated" => true, "session_token" => "Provided", "valid_session" => true} ==
             Jason.decode!(resp_body)
  end

  # TODO Add tests for the un-happy path tests here (ticket RESFRAME-3873).
end
