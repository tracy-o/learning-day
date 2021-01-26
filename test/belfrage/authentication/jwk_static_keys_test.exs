defmodule Belfrage.Authentication.JwkStaticKeysTest do
  use ExUnit.Case, async: true
  import Belfrage.Authentication.JwkStaticKeys

  test "get_static_keys/0 returns keys of configured URI" do
    defmodule TestJwk do
      use Belfrage.Authentication.JwkStaticKeys
    end

    uri = Application.get_env(:belfrage, :authentication)["account_jwk_uri"]
    expected_keys = File.read!("priv/static/#{uri |> get_filename()}") |> Jason.decode!()

    assert TestJwk.get_static_keys() == expected_keys
  end
end
