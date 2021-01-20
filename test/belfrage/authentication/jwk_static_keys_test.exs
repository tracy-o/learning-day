defmodule Belfrage.Authentication.JwkStaticKeysTest do
  use ExUnit.Case, async: true
  import Belfrage.Authentication.JwkStaticKeys

  #  grabs a list of JWK endpoints directly from Cosmos config, i.e.:
  #  ["https://access.test.api.bbc.com/v1/oauth/connect/jwk_uri",
  #  "https://access.api.bbc.com/v1/oauth/connect/jwk_uri"]
  @jwk_uri File.read!("cosmos_config/belfrage.json")
           |> Jason.decode!()
           |> Enum.find(fn config -> config["name"] == "ACCOUNT_JWK_URI" end)
           |> Map.get("options")
           |> Enum.map(fn uri -> uri["value"] end)

  for uri <- @jwk_uri do
    @uri uri
    test "priv directory contains static file for #{uri}" do
      assert File.exists?("priv/static/#{@uri |> get_filename()}")
    end
  end

  test "get_static_keys/0 returns keys of configured URI" do
    defmodule TestJwk do
      use Belfrage.Authentication.JwkStaticKeys
    end

    uri = Application.get_env(:belfrage, :authentication)["account_jwk_uri"]
    expected_keys = File.read!("priv/static/#{uri |> get_filename()}") |> Jason.decode!()

    assert TestJwk.get_static_keys() == expected_keys
  end
end
