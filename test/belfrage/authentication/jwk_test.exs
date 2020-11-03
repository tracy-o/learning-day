defmodule Belfrage.Authentication.JwkTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  alias Belfrage.Clients.AccountMock
  alias Belfrage.Authentication.Jwk

  @expected_jwk_response %{
    "keys" => Fixtures.AuthToken.keys()
  }

  test "get_keys/0 requests the keys from the account client" do
    AccountMock
    |> expect(:get_jwk_keys, fn -> {:ok, @expected_jwk_response} end)

    Jwk.refresh_now()

    assert @expected_jwk_response == Jwk.get_keys()
  end
end
