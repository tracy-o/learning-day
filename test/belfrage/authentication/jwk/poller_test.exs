defmodule Belfrage.Authentication.JWK.PollerTest do
  # Can't be async because it updates the state of Belfrage.Authentication.JWK
  # which is a global resource
  use ExUnit.Case
  use Test.Support.Helper, :mox
  import Test.Support.Helper, only: [wait_for: 1]

  alias Belfrage.Clients.AuthenticationMock, as: AuthenticationClient
  alias Belfrage.Authentication.JWK
  alias Belfrage.Authentication.JWK.Poller

  test "fetches and updates JWK keys from the API" do
    assert JWK.get("foo", "bar") == {:error, :public_key_not_found}

    stub_jwk_api({:ok, %{"keys" => [%{"alg" => "foo", "kid" => "bar"}]}})
    start_supervised!({Poller, interval: 0, name: :test_jwk_poller})
    wait_for(fn -> JWK.get("foo", "bar") |> elem(0) == :ok end)

    stub_jwk_api({:ok, %{"keys" => []}})
    wait_for(fn -> JWK.get("foo", "bar") == {:error, :public_key_not_found} end)

    # Restore the state
    JWK.update(Fixtures.AuthToken.keys())
  end

  defp stub_jwk_api(response) do
    stub(AuthenticationClient, :get_jwk_keys, fn -> response end)
  end
end
