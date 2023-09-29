defmodule EndToEnd.PersonalisedAccountTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox

  alias BelfrageWeb.Router
  alias Belfrage.Clients.LambdaMock
  alias Fixtures.AuthToken
  alias Belfrage.Authentication.BBCID

  @moduledoc """
  Integration tests for the /foryou route.
  """

  @moduletag :end_to_end

  @lambda_response %{
    "headers" => %{
      "cache-control" => "private"
    },
    "statusCode" => 200,
    "body" => "<h1>Hello from the Lambda!</h1>"
  }
  @valid_token AuthToken.valid_access_token()
  @valid_token_without_user_attributes AuthToken.valid_access_token_without_user_attributes()
  @valid_vary_co_uk [
    "Accept-Encoding,X-BBC-Edge-Cache,X-BBC-Edge-Country,X-BBC-Edge-IsUK,X-BBC-Edge-Scheme,cookie-ckns_bbccom_beta,x-id-oidc-signedin"
  ]
  @valid_vary_com [
    "Accept-Encoding,X-BBC-Edge-Cache,X-BBC-Edge-Country,X-BBC-Edge-IsUK,X-BBC-Edge-Scheme,cookie-ckns_bbccom_beta"
  ]
  @valid_vary_account_unavailable [
    "Accept-Encoding,X-BBC-Edge-Cache,X-BBC-Edge-Country,X-BBC-Edge-IsUK,X-BBC-Edge-Scheme,cookie-ckns_bbccom_beta"
  ]

  @default_bbcid_state %{
    id_availability: true,
    foryou_flagpole: false,
    foryou_access_chance: 0,
    foryou_allowlist: []
  }

  setup do
    stub_dial(:personalisation, "on")
    :ets.delete_all_objects(:cache)
    old_state = Agent.get(BBCID, & &1)
    on_exit(fn -> Agent.update(BBCID, fn _ -> old_state end) end)
    Agent.update(BBCID, fn _state -> @default_bbcid_state end)
    :ok
  end

  describe "redirects" do
    test "to account path if request is_uk is false" do
      conn =
        conn(:get, "/foryou")
        |> put_req_header("x-bbc-edge-cache", "1")
        |> put_req_header("x-bbc-edge-host", "www.bbc.co.uk")
        |> put_req_header("x-bbc-edge-isuk", "no")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert conn.status == 302
      assert get_resp_header(conn, "location") == ["https://www.bbc.co.uk/account"]

      assert get_resp_header(conn, "vary") == @valid_vary_co_uk
    end

    test "to .co.uk/foryou path if request to .com/foryou, and user is in uk" do
      conn =
        conn(:get, "/foryou")
        |> put_req_header("x-bbc-edge-cache", "1")
        |> put_req_header("x-bbc-edge-host", "www.bbc.com")
        |> put_req_header("x-bbc-edge-isuk", "yes")
        |> put_req_header("x-id-oidc-signedin", "0")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert conn.status == 302
      assert get_resp_header(conn, "location") == ["https://www.bbc.co.uk/foryou"]

      assert get_resp_header(conn, "vary") == @valid_vary_com
    end

    test "to sign in path if is_uk true, but user not authenticated" do
      conn =
        conn(:get, "/foryou")
        |> put_req_header("x-bbc-edge-cache", "1")
        |> put_req_header("x-bbc-edge-host", "www.bbc.co.uk")
        |> put_req_header("x-bbc-edge-isuk", "yes")
        |> put_req_header("x-id-oidc-signedin", "0")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert conn.status == 302

      assert get_resp_header(conn, "location") == [
               "https://session.bbc.co.uk/session?ptrt=https%3A%2F%2Fwww.bbc.co.uk%2Fforyou"
             ]

      assert get_resp_header(conn, "vary") == @valid_vary_co_uk
    end

    test "to account path if request is_uk true, user is authenticated, but no age_bracket in user attributes" do
      conn =
        conn(:get, "/foryou")
        |> put_req_header("x-bbc-edge-host", "www.bbc.co.uk")
        |> put_req_header("x-bbc-edge-cache", "1")
        |> put_req_header("x-bbc-edge-isuk", "yes")
        |> put_req_header("x-id-oidc-signedin", "1")
        |> put_req_header("cookie", "ckns_atkn=#{@valid_token_without_user_attributes}")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert conn.status == 302
      assert get_resp_header(conn, "location") == ["https://www.bbc.co.uk/account"]
      assert get_resp_header(conn, "vary") == @valid_vary_co_uk
    end

    test "if request is_uk, user is authenticated and over 13, allow_personalisation is true or present, profile cookie is absent and foryou flagpole is false" do
      conn =
        conn(:get, "/foryou")
        |> put_req_header("x-bbc-edge-host", "www.bbc.co.uk")
        |> put_req_header("x-bbc-edge-cache", "1")
        |> put_req_header("x-bbc-edge-isuk", "yes")
        |> put_req_header("x-id-oidc-signedin", "1")
        |> put_req_header("cookie", "ckns_atkn=#{@valid_token}")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert conn.status == 302
      assert get_resp_header(conn, "location") == ["https://www.bbc.co.uk/account"]
      assert get_resp_header(conn, "vary") == @valid_vary_co_uk
    end

    test "if request is_uk, user is authenticated and over 13, allow_personalisation is true or present, profile cookie is absent and foryou access chance is 0" do
      Agent.update(BBCID, fn _state -> %{@default_bbcid_state | foryou_flagpole: true} end)

      conn =
        conn(:get, "/foryou")
        |> put_req_header("x-bbc-edge-host", "www.bbc.co.uk")
        |> put_req_header("x-bbc-edge-cache", "1")
        |> put_req_header("x-bbc-edge-isuk", "yes")
        |> put_req_header("x-id-oidc-signedin", "1")
        |> put_req_header("cookie", "ckns_atkn=#{@valid_token}")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert conn.status == 302
      assert get_resp_header(conn, "location") == ["https://www.bbc.co.uk/account"]
      assert get_resp_header(conn, "vary") == @valid_vary_co_uk
    end

    test "if request is_uk, user is authenticated and ckns_atkn is absent" do
      conn =
        conn(:get, "/foryou")
        |> put_req_header("x-bbc-edge-host", "www.bbc.co.uk")
        |> put_req_header("x-bbc-edge-cache", "1")
        |> put_req_header("x-bbc-edge-isuk", "yes")
        |> put_req_header("x-id-oidc-signedin", "1")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert conn.status == 302

      assert get_resp_header(conn, "location") == [
               "https://session.bbc.co.uk/session?ptrt=https%3A%2F%2Fwww.bbc.co.uk%2Fforyou"
             ]

      assert get_resp_header(conn, "vary") == @valid_vary_co_uk
    end

    test "if request is_uk, user is authenticated and ckns_atkn is invalid" do
      conn =
        conn(:get, "/foryou")
        |> put_req_header("x-bbc-edge-host", "www.bbc.co.uk")
        |> put_req_header("x-bbc-edge-cache", "1")
        |> put_req_header("x-bbc-edge-isuk", "yes")
        |> put_req_header("x-id-oidc-signedin", "1")
        |> put_req_header("cookie", "ckns_atkn=#{AuthToken.invalid_access_token()}")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert conn.status == 302

      assert get_resp_header(conn, "location") == [
               "https://session.bbc.co.uk/session?ptrt=https%3A%2F%2Fwww.bbc.co.uk%2Fforyou"
             ]

      assert get_resp_header(conn, "vary") == @valid_vary_co_uk
    end
  end

  describe "does not redirect" do
    test "if request is_uk, user is authenticated and over 13, allow_personalisation is true or present, profile cookie is absent, foryou flagpole is true and access chance is 100" do
      Agent.update(BBCID, fn _state -> %{@default_bbcid_state | foryou_access_chance: 100, foryou_flagpole: true} end)

      expect(LambdaMock, :call, fn _credentials, _arn, _request, _ ->
        {:ok, @lambda_response}
      end)

      conn =
        conn(:get, "/foryou")
        |> put_req_header("x-bbc-edge-host", "www.bbc.co.uk")
        |> put_req_header("x-bbc-edge-cache", "1")
        |> put_req_header("x-bbc-edge-isuk", "yes")
        |> put_req_header("x-id-oidc-signedin", "1")
        |> put_req_header("cookie", "ckns_atkn=#{@valid_token}")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert conn.status == 200
      assert get_resp_header(conn, "vary") == @valid_vary_co_uk
    end

    test "if request is_uk, user is authenticated and over 13, allow_personalisation is true or present, profile cookie is absent, foryou flagpole is true, access chance is 0, and user pseudonym is in allowlist" do
      Agent.update(BBCID, fn _state ->
        %{@default_bbcid_state | foryou_flagpole: true, foryou_allowlist: [Fixtures.AuthToken.valid_pseudonym_key()]}
      end)

      expect(LambdaMock, :call, fn _credentials, _arn, _request, _ ->
        {:ok, @lambda_response}
      end)

      conn =
        conn(:get, "/foryou")
        |> put_req_header("x-bbc-edge-host", "www.bbc.co.uk")
        |> put_req_header("x-bbc-edge-cache", "1")
        |> put_req_header("x-bbc-edge-isuk", "yes")
        |> put_req_header("x-id-oidc-signedin", "1")
        |> put_req_header("cookie", "ckns_atkn=#{@valid_token}")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert conn.status == 200
      assert get_resp_header(conn, "vary") == @valid_vary_co_uk
    end
  end

  describe "flagpole combinations tests" do
    test "redirect to /account if request is_uk, host is .co.uk, user is eligible and id_availability is true and foryou_flagpole is false" do
      Agent.update(BBCID, fn _state ->
        %{@default_bbcid_state | foryou_access_chance: 100, id_availability: true, foryou_flagpole: false}
      end)

      conn =
        conn(:get, "/foryou")
        |> put_req_header("x-bbc-edge-host", "www.bbc.co.uk")
        |> put_req_header("x-bbc-edge-cache", "1")
        |> put_req_header("x-bbc-edge-isuk", "yes")
        |> put_req_header("x-id-oidc-signedin", "1")
        |> put_req_header("cookie", "ckns_atkn=#{@valid_token}")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert conn.status == 302
      assert get_resp_header(conn, "location") == ["https://www.bbc.co.uk/account"]
      assert get_resp_header(conn, "vary") == @valid_vary_co_uk
    end

    test "do not redirect if request is_uk, host is .co.uk, user is eligible, id_availability is true and foryou_flagpole is true" do
      Agent.update(BBCID, fn _state -> %{@default_bbcid_state | foryou_access_chance: 100, foryou_flagpole: true} end)

      expect(LambdaMock, :call, fn _credentials, _arn, _request, _ ->
        {:ok, @lambda_response}
      end)

      conn =
        conn(:get, "/foryou")
        |> put_req_header("x-bbc-edge-host", "www.bbc.co.uk")
        |> put_req_header("x-bbc-edge-cache", "1")
        |> put_req_header("x-bbc-edge-isuk", "yes")
        |> put_req_header("x-id-oidc-signedin", "1")
        |> put_req_header("cookie", "ckns_atkn=#{@valid_token}")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert conn.status == 200
      assert get_resp_header(conn, "vary") == @valid_vary_co_uk
    end

    test "redirect to /account if request is_uk, host is .co.uk, user is eligible and id_availability is false and foryou_flagpole is true" do
      Agent.update(BBCID, fn _state ->
        %{@default_bbcid_state | foryou_access_chance: 100, id_availability: false, foryou_flagpole: true}
      end)

      conn =
        conn(:get, "/foryou")
        |> put_req_header("x-bbc-edge-host", "www.bbc.co.uk")
        |> put_req_header("x-bbc-edge-cache", "1")
        |> put_req_header("x-bbc-edge-isuk", "yes")
        |> put_req_header("x-id-oidc-signedin", "1")
        |> put_req_header("cookie", "ckns_atkn=#{@valid_token}")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert conn.status == 302
      assert get_resp_header(conn, "location") == ["https://www.bbc.co.uk/account"]
      assert get_resp_header(conn, "vary") == @valid_vary_account_unavailable
    end

    test "redirect to /account if request is_uk, host is .co.uk, user eligible and id_availability is false and foryou_flagpole is false" do
      Agent.update(BBCID, fn _state ->
        %{@default_bbcid_state | foryou_access_chance: 100, id_availability: false, foryou_flagpole: false}
      end)

      conn =
        conn(:get, "/foryou")
        |> put_req_header("x-bbc-edge-host", "www.bbc.co.uk")
        |> put_req_header("x-bbc-edge-cache", "1")
        |> put_req_header("x-bbc-edge-isuk", "yes")
        |> put_req_header("x-id-oidc-signedin", "1")
        |> put_req_header("cookie", "ckns_atkn=#{@valid_token}")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert conn.status == 302
      assert get_resp_header(conn, "location") == ["https://www.bbc.co.uk/account"]
      assert get_resp_header(conn, "vary") == @valid_vary_account_unavailable
    end

    test "redirect to /account if request is_uk, host is .co.uk, user is eligible and id_availability is true, foryou_flagpole is true, and access_chance is 0" do
      Agent.update(BBCID, fn _state ->
        %{@default_bbcid_state | foryou_access_chance: 0, id_availability: true, foryou_flagpole: true}
      end)

      conn =
        conn(:get, "/foryou")
        |> put_req_header("x-bbc-edge-host", "www.bbc.co.uk")
        |> put_req_header("x-bbc-edge-cache", "1")
        |> put_req_header("x-bbc-edge-isuk", "yes")
        |> put_req_header("x-id-oidc-signedin", "1")
        |> put_req_header("cookie", "ckns_atkn=#{@valid_token}")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert conn.status == 302
      assert get_resp_header(conn, "location") == ["https://www.bbc.co.uk/account"]
      assert get_resp_header(conn, "vary") == @valid_vary_co_uk
    end
  end
end
