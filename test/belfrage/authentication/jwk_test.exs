defmodule Belfrage.Authentication.JWKTest do
  use ExUnit.Case, async: true

  alias Belfrage.Authentication.JWK
  alias Fixtures.AuthToken, as: AuthFixtures

  describe "get/2" do
    test "returns static keys on startup" do
      keys = AuthFixtures.keys()

      refute keys == []

      for %{"alg" => alg, "kid" => kid} = key <- keys do
        assert JWK.get(alg, kid) == {:ok, alg, key}
      end
    end

    test "returns error if requested key doesn't exist" do
      assert JWK.get("foo", "bar") == {:error, :public_key_not_found}
    end
  end

  describe "update/1" do
    test "updates the keys" do
      pid = start_supervised!({JWK, name: :test_jwk_agent})
      assert JWK.get(pid, "foo", "bar") == {:error, :public_key_not_found}

      JWK.update(pid, [%{"alg" => "foo", "kid" => "bar"}])
      assert JWK.get(pid, "foo", "bar") == {:ok, "foo", %{"alg" => "foo", "kid" => "bar"}}
    end
  end

  describe "read_satic_keys/1" do
    test "reads keys from the passed JSON file name" do
      keys = JWK.read_static_keys("jwk_int.json")

      assert length(keys) > 0

      for key <- keys do
        assert key["alg"]
        assert key["kid"]
      end
    end
  end
end
