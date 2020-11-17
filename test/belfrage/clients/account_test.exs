defmodule Belfrage.Client.AccountTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  import ExUnit.CaptureLog

  alias Belfrage.Clients
  alias Belfrage.Clients.Account

  @authentication Application.get_env(:belfrage, :authentication)
  @error_response {:error, %Clients.HTTP.Error{reason: :timeout}}
  @error_unknown_response {:error, :einval}
  @not_200_response {:ok, %Clients.HTTP.Response{status_code: 500, body: ""}}
  @unknown_response {:ok, :unknown_response}
  @ok_response {
    :ok,
    %Clients.HTTP.Response{
      status_code: 200,
      body: Jason.encode!(%{keys: Fixtures.AuthToken.keys()})
    }
  }

  describe "Jwk" do
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

    test "logs 200-status response" do
      Clients.HTTPMock |> expect(:execute, fn _ -> @ok_response end)
      assert capture_log(fn -> Account.get_jwk_keys() end) =~ "JWK keys fetched successfully"
    end

    test "logs non 200-status response" do
      Clients.HTTPMock |> expect(:execute, fn _ -> @not_200_response end)
      assert capture_log(fn -> Account.get_jwk_keys() end) =~ "Non 200 Status Code (500) from the JWK API"
    end

    test "logs unknown response" do
      Clients.HTTPMock |> expect(:execute, fn _ -> @unknown_response end)
      assert capture_log(fn -> Account.get_jwk_keys() end) =~ "Unknown response from the JWK API"
    end

    test "logs error response" do
      Clients.HTTPMock |> expect(:execute, fn _ -> @error_response end)
      assert capture_log(fn -> Account.get_jwk_keys() end) =~ "Error received from the JWK API: timeout"
    end

    test "logs unknown http error " do
      Clients.HTTPMock |> expect(:execute, fn _ -> @error_unknown_response end)
      assert capture_log(fn -> Account.get_jwk_keys() end) =~ "Unknown error received from the JWK API"
    end
  end

  describe "IDCTA" do
    test "get_idcta_config/0 returns data from the api" do
      expected_request = %Belfrage.Clients.HTTP.Request{
        headers: %{},
        method: :get,
        payload: "",
        timeout: 6000,
        url: @authentication["account_idcta_config_uri"]
      }

      Clients.HTTPMock
      |> expect(:execute, fn ^expected_request ->
        {:ok, %Clients.HTTP.Response{status_code: 200, body: Jason.encode!(%{"id-availability": "GREEN"})}}
      end)

      assert Belfrage.Clients.AccountStub.get_idcta_config() == Account.get_idcta_config()
    end

    test "logs 200-status response" do
      Clients.HTTPMock
      |> expect(:execute, fn _ ->
        {:ok, %Clients.HTTP.Response{status_code: 200, body: Jason.encode!(%{"id-availability": "GREEN"})}}
      end)

      assert capture_log(fn -> Account.get_idcta_config() end) =~ "IDCTA config fetched successfully"
    end

    test "logs non 200-status response" do
      Clients.HTTPMock |> expect(:execute, fn _ -> @not_200_response end)
      assert capture_log(fn -> Account.get_idcta_config() end) =~ "Non 200 Status Code (500) from the IDCTA API"
    end

    test "logs unknown response" do
      Clients.HTTPMock |> expect(:execute, fn _ -> @unknown_response end)
      assert capture_log(fn -> Account.get_idcta_config() end) =~ "Unknown response from the IDCTA API"
    end

    test "logs error response" do
      Clients.HTTPMock |> expect(:execute, fn _ -> @error_response end)
      assert capture_log(fn -> Account.get_idcta_config() end) =~ "Error received from the IDCTA API: timeout"
    end

    test "logs unknown http error " do
      Clients.HTTPMock |> expect(:execute, fn _ -> @error_unknown_response end)
      assert capture_log(fn -> Account.get_idcta_config() end) =~ "Unknown error received from the IDCTA API"
    end
  end
end
