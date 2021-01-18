defmodule Belfrage.Authentication.JwkStaticKeysTest do
  use ExUnit.Case, async: true

  @jwk_uri [
    "https://access.test.api.bbc.com/v1/oauth/connect/jwk_uri",
    "https://access.api.bbc.com/v1/oauth/connect/jwk_uri"
  ]

  describe "priv directory" do
    for uri <- @jwk_uri do
      @uri uri
      test "contains static file for #{uri}" do
        assert File.exists?("priv/static/#{@uri |> Crimpex.signature()}")
      end
    end
  end

  describe "get_static_keys/0" do
    test "returns keys of configured URI" do
      defmodule TestJwk do
        use Belfrage.Authentication.JwkStaticKeys
      end

      uri = Application.get_env(:belfrage, :authentication)["account_jwk_uri"]
      expected_keys = File.read!("priv/static/#{uri |> Crimpex.signature()}") |> Jason.decode!()

      assert TestJwk.get_static_keys() == expected_keys
    end

    for uri <- @jwk_uri do
      @uri uri
      test "returns keys for #{uri}" do
        keys_filename = @uri |> Crimpex.signature()
        expected_keys = File.read!("priv/static/#{keys_filename}") |> Jason.decode!()

        contents =
          quote do
            use Belfrage.Authentication.JwkStaticKeys, uri: unquote(@uri)
          end

        test_module = Module.concat(["TestJwk", keys_filename])
        Module.create(test_module, contents, Macro.Env.location(__ENV__))

        assert test_module.get_static_keys() == expected_keys
      end
    end

    test "not compiled for unknown uri without corresponding static file" do
      assert_raise File.Error, fn ->
        defmodule TestJwkUnknownUri do
          use Belfrage.Authentication.JwkStaticKeys, uri: "https://unknown_jwk_uri"
        end
      end
    end
  end
end
