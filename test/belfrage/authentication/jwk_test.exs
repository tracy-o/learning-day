defmodule Belfrage.Authentication.JwkTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Clients.AuthenticationMock
  alias Belfrage.Authentication.Jwk

  import ExUnit.CaptureLog

  @expected_jwk_response %{
    "keys" => Fixtures.AuthToken.keys()
  }

  setup do
    start_supervised!(Belfrage.Authentication.Jwk)

    AuthenticationMock
    |> expect(:get_jwk_keys, fn -> {:ok, @expected_jwk_response} end)

    :ok
  end

  test "get_keys/0 requests the keys from the authentication client" do
    Jwk.refresh_now()

    assert Fixtures.AuthToken.keys() == Jwk.get_keys()
  end

  describe "get_key/2" do
    test "when a public key is not found" do
      alg = "bar"
      kid = "foo"

      Jwk.refresh_now()

      run_fn = fn ->
        assert {:error, :public_key_not_found} == Belfrage.Authentication.Jwk.get_key(alg, kid)
      end

      assert capture_log(run_fn) =~ ~s(Public key not found)
      assert capture_log(run_fn) =~ ~s("kid":"#{kid}")
      assert capture_log(run_fn) =~ ~s("alg":"#{alg}")
    end

    test "when a public key is found" do
      alg = "RS256"
      kid = "0ccd7c65-ff20-4500-8742-5da72ef4af67"

      Jwk.refresh_now()

      run_fn = fn ->
        assert {:ok, "RS256",
                %{"alg" => "RS256", "kid" => "0ccd7c65-ff20-4500-8742-5da72ef4af67", "kty" => "RSA", "use" => "enc"}} ==
                 Belfrage.Authentication.Jwk.get_key(alg, kid)
      end

      assert capture_log(run_fn) =~ ~s(Public key found)
      assert capture_log(run_fn) =~ ~s("kid":"#{kid}")
      assert capture_log(run_fn) =~ ~s("alg":"#{alg}")
    end
  end
end
