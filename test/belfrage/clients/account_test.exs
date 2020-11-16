defmodule Belfrage.Client.AccountTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  import ExUnit.CaptureLog

  alias Belfrage.Clients
  alias Belfrage.Clients.Account

  @authentication Application.get_env(:belfrage, :authentication)
  @error_response {:error, %Clients.HTTP.Error{reason: :timeout}}
  @ok_response {
    :ok,
    %Clients.HTTP.Response{
      status_code: 200,
      body: Jason.encode!(%{keys: Fixtures.AuthToken.keys()})
    }
  }

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

  test "logs error response" do
    Clients.HTTPMock |> expect(:execute, fn _ -> @error_response end)
    assert capture_log(fn -> Account.get_jwk_keys() end) =~ "Error received from the JWK API: timeout"
  end

  test "logs unknown error response" do
    Clients.HTTPMock |> expect(:execute, fn _ -> {:error, nil} end)
    assert capture_log(fn -> Account.get_jwk_keys() end) =~ "Unknown error received from the JWK API"
  end
end
