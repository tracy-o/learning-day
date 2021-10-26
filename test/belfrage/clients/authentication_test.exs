defmodule Belfrage.Client.AuthenticationTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  import ExUnit.CaptureLog
  import Belfrage.Test.MetricsHelper, only: [intercept_metric: 2]

  alias Belfrage.Clients.{HTTP, HTTPMock, Authentication, AuthenticationStub}

  @authentication Application.get_env(:belfrage, :authentication)

  @error_response {:error, %HTTP.Error{reason: :timeout}}
  @error_unknown_response {:error, :einval}

  @not_200_response {:ok, %HTTP.Response{status_code: 500, body: ""}}
  @malformed_json_response {:ok, %HTTP.Response{status_code: 200, body: "malformed json"}}
  @unknown_response {:ok, :unknown_response}
  @ok_response {
    :ok,
    %HTTP.Response{
      status_code: 200,
      body: Jason.encode!(%{keys: Fixtures.AuthToken.keys()})
    }
  }

  @idcta_api_config_key "idcta_config_uri"
  @jwk_api_config_key "account_jwk_uri"

  describe "get_jwk_keys/0" do
    test "returns the keys from the account api" do
      expected_request = %HTTP.Request{
        headers: %{
          "connection" => "close"
        },
        method: :get,
        payload: "",
        timeout: 6000,
        url: @authentication["account_jwk_uri"]
      }

      HTTPMock
      |> expect(:execute, fn ^expected_request, :AccountAuthentication -> @ok_response end)

      assert AuthenticationStub.get_jwk_keys() == Authentication.get_jwk_keys()
    end

    test "logs 200-status response" do
      HTTPMock |> expect(:execute, fn _, :AccountAuthentication -> @ok_response end)
      assert capture_log(fn -> Authentication.get_jwk_keys() end) =~ "JWK keys fetched successfully"
    end

    test "logs non 200-status response" do
      HTTPMock |> expect(:execute, fn _, :AccountAuthentication -> @not_200_response end)

      assert capture_log(fn -> Authentication.get_jwk_keys() end) =~
               "Non 200 Status Code (500) from #{@jwk_api_config_key}"
    end

    test "logs unknown response" do
      HTTPMock |> expect(:execute, fn _, :AccountAuthentication -> @unknown_response end)
      assert capture_log(fn -> Authentication.get_jwk_keys() end) =~ "Unknown response from #{@jwk_api_config_key}"
    end

    test "logs error response" do
      HTTPMock |> expect(:execute, fn _, :AccountAuthentication -> @error_response end)

      assert capture_log(fn -> Authentication.get_jwk_keys() end) =~
               "Error received from #{@jwk_api_config_key}: timeout"
    end

    test "logs unknown http error" do
      HTTPMock |> expect(:execute, fn _, :AccountAuthentication -> @error_unknown_response end)

      assert capture_log(fn -> Authentication.get_jwk_keys() end) =~
               "Unknown error received from #{@jwk_api_config_key}"
    end

    test "handles malformed JSON" do
      HTTPMock |> expect(:execute, fn _, :AccountAuthentication -> @malformed_json_response end)

      assert capture_log(fn -> Authentication.get_jwk_keys() end) =~
               "Error while decoding data from #{@jwk_api_config_key}"
    end

    test "tracks the duration of the request" do
      stub(HTTPMock, :execute, fn _, :AccountAuthentication -> @ok_response end)

      metric =
        intercept_metric([:request, :jwk, :stop], fn ->
          Authentication.get_jwk_keys()
        end)

      assert {_, %{duration: duration}, _} = metric
      assert duration > 0
    end
  end

  describe "get_idcta_config/0" do
    test "returns data from the api" do
      expected_request = %HTTP.Request{
        headers: %{
          "connection" => "close"
        },
        method: :get,
        payload: "",
        timeout: 6000,
        url: @authentication["idcta_config_uri"]
      }

      HTTPMock
      |> expect(:execute, fn ^expected_request, :AccountAuthentication ->
        {:ok, %HTTP.Response{status_code: 200, body: Jason.encode!(%{"id-availability": "RED"})}}
      end)

      assert AuthenticationStub.get_idcta_config() == Authentication.get_idcta_config()
    end

    test "logs 200-status response" do
      HTTPMock
      |> expect(:execute, fn _, :AccountAuthentication ->
        {:ok, %HTTP.Response{status_code: 200, body: Jason.encode!(%{"id-availability": "GREEN"})}}
      end)

      assert capture_log(fn -> Authentication.get_idcta_config() end) =~ "IDCTA config fetched successfully"
    end

    test "logs non 200-status response" do
      HTTPMock |> expect(:execute, fn _, :AccountAuthentication -> @not_200_response end)

      assert capture_log(fn -> Authentication.get_idcta_config() end) =~
               "Non 200 Status Code (500) from #{@idcta_api_config_key}"
    end

    test "logs unknown response" do
      HTTPMock |> expect(:execute, fn _, :AccountAuthentication -> @unknown_response end)

      assert capture_log(fn -> Authentication.get_idcta_config() end) =~
               "Unknown response from #{@idcta_api_config_key}"
    end

    test "logs error response" do
      HTTPMock |> expect(:execute, fn _, :AccountAuthentication -> @error_response end)

      assert capture_log(fn -> Authentication.get_idcta_config() end) =~
               "Error received from #{@idcta_api_config_key}: timeout"
    end

    test "logs unknown http error " do
      HTTPMock |> expect(:execute, fn _, :AccountAuthentication -> @error_unknown_response end)

      assert capture_log(fn -> Authentication.get_idcta_config() end) =~
               "Unknown error received from #{@idcta_api_config_key}"
    end

    test "handles malformed JSON" do
      HTTPMock |> expect(:execute, fn _, :AccountAuthentication -> @malformed_json_response end)

      assert capture_log(fn -> Authentication.get_idcta_config() end) =~
               "Error while decoding data from #{@idcta_api_config_key}"
    end

    test "tracks the duration of the request" do
      stub(HTTPMock, :execute, fn _, :AccountAuthentication -> @ok_response end)

      metric =
        intercept_metric([:request, :idcta_config, :stop], fn ->
          Authentication.get_idcta_config()
        end)

      assert {_, %{duration: duration}, _} = metric
      assert duration > 0
    end
  end
end
