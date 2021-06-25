defmodule Belfrage.Authentication.SessionStateTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Authentication.SessionState
  alias Belfrage.Authentication.Jwk

  @token Fixtures.AuthToken.valid_access_token()

  setup do
    :set_mox_global
    start_supervised!(Jwk)

    :ok
  end

  describe "add/3  function" do
    test "returns authenticated state when 'ckns_atkn' cookie set, 'x-id-oidc-signedin' header is 1" do
      cookies = %{"ckns_atkn" => @token}
      headers = %{"x-id-oidc-signedin" => "1"}
      user_attributes = %{age_bracket: "o18", allow_personalisation: true}

      assert %{
               authentication_environment: "int",
               session_token: @token,
               authenticated: true,
               valid_session: true,
               user_attributes: ^user_attributes
             } = SessionState.build(cookies, headers, "/")
    end

    test "returns authenticated state when 'ckns_atkn' and 'ckns_id' cookies are set" do
      cookies = %{"ckns_atkn" => @token, "ckns_id" => "1234"}
      headers = %{}
      user_attributes = %{age_bracket: "o18", allow_personalisation: true}

      assert %{
               authentication_environment: "int",
               session_token: @token,
               authenticated: true,
               valid_session: true,
               user_attributes: ^user_attributes
             } = SessionState.build(cookies, headers, "/")
    end

    test "returns unauthenticated state when only 'ckns_atkn' cookie set" do
      cookies = %{"ckns_atkn" => @token}
      headers = %{}

      assert %{
               authentication_environment: "int",
               session_token: nil,
               authenticated: false,
               valid_session: false,
               user_attributes: %{}
             } = SessionState.build(cookies, headers, "/")
    end

    test "returns authenticated only state when 'ckns_id' cookie only is set" do
      cookies = %{"ckns_id" => "1234"}
      headers = %{}

      assert %{
               authentication_environment: "int",
               session_token: nil,
               authenticated: true,
               valid_session: false,
               user_attributes: %{}
             } = SessionState.build(cookies, headers, "/")
    end

    test "returns authenticated only state when 'ckns_atkn' cookie not set, 'x-id-oidc-signedin' header is 1" do
      cookies = %{}
      headers = %{"x-id-oidc-signedin" => "1"}

      assert %{
               authentication_environment: "int",
               session_token: nil,
               authenticated: true,
               valid_session: false,
               user_attributes: %{}
             } = SessionState.build(cookies, headers, "/")
    end

    test "returns unauthenticated state when 'ckns_atkn' cookie not set, 'x-id-oidc-signedin' header is 0" do
      cookies = %{}
      headers = %{"x-id-oidc-signedin" => "0"}

      assert %{
               authentication_environment: "int",
               session_token: nil,
               authenticated: false,
               valid_session: false,
               user_attributes: %{}
             } = SessionState.build(cookies, headers, "/")
    end

    test "returns unauthenticated state when both 'ckns_atkn' cookie and 'x-id-oidc-signedin' header not set" do
      cookies = %{}
      headers = %{}

      assert %{
               authentication_environment: "int",
               session_token: nil,
               authenticated: false,
               valid_session: false,
               user_attributes: %{}
             } = SessionState.build(cookies, headers, "/")
    end

    test "returns authenticated state when 'ckns_atkn' cookie set to FAKETOKEN and path is /full-stack-test/a/ft" do
      cookies = %{"ckns_atkn" => "FAKETOKEN"}
      headers = %{}

      assert %{
               authentication_environment: "int",
               session_token: "FAKETOKEN",
               authenticated: true,
               valid_session: true,
               user_attributes: %{}
             } = SessionState.build(cookies, headers, "/full-stack-test/a/ft")
    end

    test "returns unauthenticated state when 'ckns_atkn' cookie set to FAKETOKEN and path is NOT /full-stack-test/a/ft" do
      cookies = %{"ckns_atkn" => "FAKETOKEN"}
      headers = %{}

      assert %{
               authentication_environment: "int",
               session_token: nil,
               authenticated: false,
               valid_session: false,
               user_attributes: %{}
             } = SessionState.build(cookies, headers, "/")
    end
  end
end
