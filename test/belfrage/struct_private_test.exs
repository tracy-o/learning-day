defmodule Belfrage.StructPrivateTest do
  use ExUnit.Case, async: true
  alias Belfrage.Struct.Private

  @token Fixtures.AuthToken.valid_access_token()

  describe "set_session_state/4 modifier function" do
    test "returns authenticated state when 'ckns_atkn' cookie set, 'x-id-oidc-signedin' header is 1" do
      cookies = %{"ckns_atkn" => @token}
      headers = %{"x-id-oidc-signedin" => "1"}
      valid_session? = true
      user_attributes  = %{age_bracket: "o18", allow_personalisation: true}

      assert %Private{
               authenticated: true,
               session_token: @token,
               valid_session: true
             } = Private.set_session_state(%Private{}, cookies, headers, {valid_session?, user_attributes})
    end

    test "returns authenticated state when 'ckns_atkn' and 'ckns_id' cookies are set" do
      cookies = %{"ckns_atkn" => @token, "ckns_id" => "1234"}
      headers = %{}
      valid_session? = true
      user_attributes  = %{age_bracket: "o18", allow_personalisation: true}

      assert %Private{
               authenticated: true,
               session_token: @token,
               valid_session: true
             } = Private.set_session_state(%Private{}, cookies, headers, {valid_session?, user_attributes})
    end

    test "returns unauthenticated state when only 'ckns_atkn' cookie set" do
      cookies = %{"ckns_atkn" => @token}
      headers = %{}
      valid_session? = false
      user_attributes  = %{age_bracket: "o18", allow_personalisation: true}

      assert %Private{
               authenticated: false,
               session_token: nil,
               valid_session: false
             } = Private.set_session_state(%Private{}, cookies, headers, {valid_session?, user_attributes})
    end

    test "returns authenticated only state when 'ckns_id' cookie only is set" do
      cookies = %{"ckns_id" => "1234"}
      headers = %{}
      valid_session? = false
      user_attributes  = %{age_bracket: "o18", allow_personalisation: true}

      assert %Private{
               authenticated: true,
               session_token: nil,
               valid_session: false
             } = Private.set_session_state(%Private{}, cookies, headers, {valid_session?, user_attributes})
    end

    test "returns authenticated only state when 'ckns_atkn' cookie not set, 'x-id-oidc-signedin' header is 1" do
      cookies = %{}
      headers = %{"x-id-oidc-signedin" => "1"}
      valid_session? = false
      user_attributes = %{age_bracket: "o18", allow_personalisation: true}

      assert %Private{
               authenticated: true,
               session_token: nil,
               valid_session: false
             } = Private.set_session_state(%Private{}, cookies, headers, {valid_session?, user_attributes})
    end

    test "returns unauthenticated state when 'ckns_atkn' cookie not set, 'x-id-oidc-signedin' header is 0" do
      cookies = %{}
      headers = %{"x-id-oidc-signedin" => "0"}
      valid_session? = false
      user_attributes = %{age_bracket: "o18", allow_personalisation: true}

      assert %Private{
               authenticated: false,
               session_token: nil,
               valid_session: false
             } = Private.set_session_state(%Private{}, cookies, headers, {valid_session?, user_attributes})
    end

    test "returns unauthenticated state when both 'ckns_atkn' cookie and 'x-id-oidc-signedin' header not set" do
      cookies = %{}
      headers = %{}
      valid_session? = false
      user_attributes = %{age_bracket: "o18", allow_personalisation: true}

      assert %Private{
               authenticated: false,
               session_token: nil,
               valid_session: false
             } = Private.set_session_state(%Private{}, cookies, headers, {valid_session?, user_attributes})
    end
  end
end
