defmodule Belfrage.Authentication.VerifyHookTest do
  use ExUnit.Case
  alias Belfrage.Authentication.VerifyHook

  setup do
    %{
      valid_access_token: Fixtures.AuthToken.valid_access_token()
    }
  end

  describe "before_verify/2" do
    test "returns a signer", %{valid_access_token: jwt} do
      opts = []

      assert {:cont, {^jwt, %Joken.Signer{}}} = VerifyHook.before_verify(opts, {jwt, %Joken.Signer{}})
    end
  end
end
