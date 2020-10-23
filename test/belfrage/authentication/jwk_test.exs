defmodule Belfrage.Authentication.JwkTest do
  use ExUnit.Case

  alias Belfrage.Authentication.Jwk

  @expected_jwk %{
    "keys" => [
      %{
        "alg" => "RS384",
        "e" => "AQAB",
        "kid" => "kid",
        "kty" => "RSA",
        "n" => "lkjljxbcLSJHSL",
        "use" => "enc",
        "x5c" => ["AAA"],
        "x5t" => "dskjhfkjh"
      }
    ]
  }

  describe "&get_keys/0" do
    test "returns the JWK keys" do
      assert Jwk.get_keys() == @expected_jwk
    end
  end
end
