defmodule Belfrage.Client.AccountTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  alias Belfrage.Clients
  alias Belfrage.Clients.Account

  @ok_response {
    :ok,
    %Clients.HTTP.Response{
      status_code: 200,
      body: Jason.encode!(%{keys: Fixtures.AuthToken.keys()})
    }
  }

  @authentication Application.get_env(:belfrage, :authentication)

  test "get_jwk_keys/0 returns the keys from the account api" do
    expected_request = %Belfrage.Clients.HTTP.Request{
      headers: %{},
      method: :get,
      payload: "",
      timeout: 6000,
      url: @authentication["account_jwk_uri"]
    }

    Clients.HTTPMock
    |> expect(:execute, fn ^expected_request -> @ok_response end)

    assert Belfrage.Clients.AccountStub.get_jwk_keys() == Account.get_jwk_keys()
  end
end
