defmodule Belfrage.Authentication.VerifyHookTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox
  alias Belfrage.Authentication.VerifyHook

  setup do
    %{
      valid_access_token: Fixtures.AuthToken.valid_access_token(),
      malformed_jwt: Fixtures.AuthToken.malformed_access_token(),
      invalid_access_token_header: Fixtures.AuthToken.invalid_access_token_header()
    }
  end

  describe "before_verify/2" do
    test "returns a signer", %{valid_access_token: jwt} do
      opts = []

      assert {:cont, {^jwt, %Joken.Signer{}}} = VerifyHook.before_verify(opts, {jwt, %Joken.Signer{}})
    end

    test "malformed token", %{malformed_jwt: jwt} do
      opts = []

      assert {:halt, {:error, :token_malformed}} == VerifyHook.before_verify(opts, {jwt, %Joken.Signer{}})
    end

    test "an unexpected header", %{invalid_access_token_header: jwt} do
      opts = []

      assert {:halt, {:error, :invalid_token_header}} == VerifyHook.before_verify(opts, {jwt, %Joken.Signer{}})
    end
  end

  describe "no public keys" do
    setup do
      :sys.replace_state(Belfrage.Authentication.Jwk, fn _existing_state -> %{"keys" => []} end)

      on_exit(fn ->
        :sys.replace_state(Belfrage.Authentication.Jwk, fn _existing_state -> %{"keys" => Fixtures.AuthToken.keys()} end)
      end)
    end

    test "when public key not found", %{valid_access_token: jwt} do
      opts = []

      assert {:halt, {:error, :public_key_not_found}} == VerifyHook.before_verify(opts, {jwt, %Joken.Signer{}})
    end
  end
end
