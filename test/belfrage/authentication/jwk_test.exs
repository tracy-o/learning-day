defmodule Belfrage.Authentication.JwkTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  alias Belfrage.Clients.AccountMock
  alias Belfrage.Authentication.Jwk

  @expected_jwk_keys %{
    "keys" => [
      %{
        "alg" => "ES256",
        "kid" => "SOME_EC_KEY_ID",
        "kty" => "EC",
        "use" => "sig",
        "crv" => "P-256",
        "x" => "EVs_o5-uQbTjL3chynL4wXgUg2R9q9UU8I5mEovUf84",
        "y" => "kGe5DgSIycKp8w9aJmoHhB1sB3QTugfnRWm5nU_TzsY"
      }
    ]
  }

  @ok_response {
    :ok,
    @expected_jwk_keys
  }

  test "get_keys/0 requests the keys from the account client" do
    AccountMock
    |> expect(:get_jwk_keys, fn -> @ok_response end)

    Jwk.refresh_now()

    assert @expected_jwk_keys == Jwk.get_keys()
  end
end
