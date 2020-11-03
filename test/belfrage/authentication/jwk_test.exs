defmodule Belfrage.Authentication.JwkTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  alias Belfrage.Clients.AccountMock
  alias Belfrage.Authentication.Jwk

  @expected_jwk %{
    "keys" => Fixtures.AuthToken.keys()
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
