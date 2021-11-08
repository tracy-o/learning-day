defmodule Belfrage.Authentication.VerifyHookTest do
  use ExUnit.Case, async: true

  alias Belfrage.Authentication.VerifyHook
  alias Fixtures.AuthToken

  describe "before_verify/2" do
    test "returns a signer" do
      jwt = AuthToken.valid_access_token()
      opts = []

      assert {:cont, {^jwt, %Joken.Signer{}}} = VerifyHook.before_verify(opts, {jwt, %Joken.Signer{}})
    end

    test "malformed token" do
      jwt = AuthToken.malformed_access_token()
      opts = []

      assert {:halt, {:error, :token_malformed}} == VerifyHook.before_verify(opts, {jwt, %Joken.Signer{}})
    end

    test "an invalid token header" do
      jwt = AuthToken.invalid_access_token_header()
      opts = []

      assert {:halt, {:error, :invalid_token_header}} == VerifyHook.before_verify(opts, {jwt, %Joken.Signer{}})
    end

    test "an invalid key token" do
      jwt = AuthToken.invalid_key_token()
      opts = []

      assert {:halt, {:error, :public_key_not_found}} == VerifyHook.before_verify(opts, {jwt, %Joken.Signer{}})
    end
  end
end
