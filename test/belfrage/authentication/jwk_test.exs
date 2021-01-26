defmodule Belfrage.Authentication.JwkTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Clients.AuthenticationMock
  alias Belfrage.Authentication.Jwk

  import ExUnit.CaptureLog
  import Belfrage.Authentication.JwkStaticKeys

  @expected_jwk_response %{
    "keys" => Fixtures.AuthToken.keys()
  }

  test "init/1" do
    jwk_uri = Application.get_env(:belfrage, :authentication)["account_jwk_uri"]
    expected_keys_data = File.read!("priv/static/#{jwk_uri |> get_filename()}") |> Jason.decode!()

    assert Jwk.init([]) == {:ok, expected_keys_data}
  end

  test "use of static JWK keys as fallback" do
    stub(AuthenticationMock, :get_jwk_keys, fn -> {:error, %{}} end)
    start_supervised!(Jwk)

    jwk_uri = Application.get_env(:belfrage, :authentication)["account_jwk_uri"]
    expected_keys_data = File.read!("priv/static/#{jwk_uri |> get_filename()}") |> Jason.decode!()

    assert Jwk.get_keys() == expected_keys_data["keys"]
  end

  test "get_keys/0 requests the keys from the authentication client" do
    start_supervised!(Jwk)

    AuthenticationMock
    |> expect(:get_jwk_keys, fn -> {:ok, @expected_jwk_response} end)

    Jwk.refresh_now()
    assert Fixtures.AuthToken.keys() == Jwk.get_keys()
  end

  describe "get_key/2" do
    setup do
      start_supervised!(Jwk)

      AuthenticationMock
      |> expect(:get_jwk_keys, fn -> {:ok, @expected_jwk_response} end)

      :ok
    end

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
