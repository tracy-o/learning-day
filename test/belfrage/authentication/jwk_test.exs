defmodule Belfrage.Authentication.JwkTest do
  use ExUnit.Case

  alias Belfrage.Authentication.Jwk

  @expected_jwk %{
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

  describe "&get_keys/0" do
    test "returns the JWK keys" do
      assert Jwk.get_keys() == @expected_jwk
    end
  end
end
