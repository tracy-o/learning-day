defmodule Belfrage.Authentication.SessionStateTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Authentication.SessionState
  alias Belfrage.Struct.Request

  @token Fixtures.AuthToken.valid_access_token()

  describe "authenticated?/1" do
    test "returns true if ckns_id cookie is set" do
      refute SessionState.authenticated?(%Request{})
      assert SessionState.authenticated?(%Request{cookies: %{"ckns_id" => "foo"}})
    end

    test "returns true if x-id-oidc-signedin header is set to '1'" do
      refute SessionState.authenticated?(%Request{})
      refute SessionState.authenticated?(%Request{raw_headers: %{"x-id-oidc-signedin" => "0"}})
      assert SessionState.authenticated?(%Request{raw_headers: %{"x-id-oidc-signedin" => "1"}})
    end
  end

  describe "build/1" do
    test "returns authenticated state when 'ckns_atkn' cookie set, 'x-id-oidc-signedin' header is 1" do
      request = %Request{
        path: "/",
        cookies: %{"ckns_atkn" => @token},
        raw_headers: %{"x-id-oidc-signedin" => "1"}
      }

      user_attributes = %{age_bracket: "o18", allow_personalisation: true}

      assert SessionState.build(request) == %{
               authentication_env: "int",
               session_token: @token,
               authenticated: true,
               valid_session: true,
               user_attributes: user_attributes
             }
    end

    test "returns authenticated state when 'ckns_atkn' and 'ckns_id' cookies are set" do
      request = %Request{
        path: "/",
        cookies: %{"ckns_atkn" => @token, "ckns_id" => "1234"}
      }

      user_attributes = %{age_bracket: "o18", allow_personalisation: true}

      assert SessionState.build(request) == %{
               authentication_env: "int",
               session_token: @token,
               authenticated: true,
               valid_session: true,
               user_attributes: user_attributes
             }
    end

    test "returns unauthenticated state when only 'ckns_atkn' cookie set" do
      request = %Request{
        path: "/",
        cookies: %{"ckns_atkn" => @token}
      }

      assert SessionState.build(request) == %{
               authentication_env: "int",
               session_token: nil,
               authenticated: false,
               valid_session: false,
               user_attributes: %{}
             }
    end

    test "returns authenticated only state when 'ckns_id' cookie only is set" do
      request = %Request{
        path: "/",
        cookies: %{"ckns_id" => "1234"}
      }

      assert SessionState.build(request) == %{
               authentication_env: "int",
               session_token: nil,
               authenticated: true,
               valid_session: false,
               user_attributes: %{}
             }
    end

    test "returns authenticated only state when 'ckns_atkn' cookie not set, 'x-id-oidc-signedin' header is 1" do
      request = %Request{
        path: "/",
        raw_headers: %{"x-id-oidc-signedin" => "1"}
      }

      assert SessionState.build(request) == %{
               authentication_env: "int",
               session_token: nil,
               authenticated: true,
               valid_session: false,
               user_attributes: %{}
             }
    end

    test "returns unauthenticated state when 'ckns_atkn' cookie not set, 'x-id-oidc-signedin' header is 0" do
      request = %Request{
        path: "/",
        raw_headers: %{"x-id-oidc-signedin" => "0"}
      }

      assert SessionState.build(request) == %{
               authentication_env: "int",
               session_token: nil,
               authenticated: false,
               valid_session: false,
               user_attributes: %{}
             }
    end

    test "returns unauthenticated state when both 'ckns_atkn' cookie and 'x-id-oidc-signedin' header not set" do
      assert SessionState.build(%Request{path: "/"}) == %{
               authentication_env: "int",
               session_token: nil,
               authenticated: false,
               valid_session: false,
               user_attributes: %{}
             }
    end

    test "returns authenticated state when 'ckns_atkn' cookie set to FAKETOKEN and path is /full-stack-test/a/ft" do
      request = %Request{
        path: "/full-stack-test/a/ft",
        cookies: %{"ckns_atkn" => "FAKETOKEN"}
      }

      assert SessionState.build(request) == %{
               authentication_env: "int",
               session_token: "FAKETOKEN",
               authenticated: true,
               valid_session: true,
               user_attributes: %{}
             }
    end

    test "returns unauthenticated state when 'ckns_atkn' cookie set to FAKETOKEN and path is NOT /full-stack-test/a/ft" do
      request = %Request{
        path: "/",
        cookies: %{"ckns_atkn" => "FAKETOKEN"}
      }

      assert SessionState.build(request) == %{
               authentication_env: "int",
               session_token: nil,
               authenticated: false,
               valid_session: false,
               user_attributes: %{}
             }
    end
  end

  describe "authentication_env/1" do
    test "returns live for live access url" do
      url = "https://access.api.bbc.com/v1/oauth/connect/jwk_uri"
      assert SessionState.authentication_env(url) == "live"
    end

    test "returns stage for stage access url" do
      url = "https://access.stage.api.bbc.com/v1/oauth/connect/jwk_uri"
      assert SessionState.authentication_env(url) == "stage"
    end

    test "returns test for test access url" do
      url = "https://access.test.api.bbc.com/v1/oauth/connect/jwk_uri"
      assert SessionState.authentication_env(url) == "test"
    end

    test "returns int for int access url" do
      url = "https://access.int.api.bbc.com/v1/oauth/connect/jwk_uri"
      assert SessionState.authentication_env(url) == "int"
    end

    test "raise on invalid url" do
      url = "https://foo.bar/v1/oauth/connect/jwk_uri"

      assert_raise KeyError, fn ->
        SessionState.authentication_env(url)
      end
    end
  end
end
