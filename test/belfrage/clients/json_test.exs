defmodule Belfrage.Client.JsonTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  import ExUnit.CaptureLog
  import Belfrage.Test.MetricsHelper, only: [intercept_metric: 2]

  alias Belfrage.Clients.{HTTP, HTTPMock, Json}

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
      body: "{\"keys\": [{\"alg\": \"foo\", \"kid\": \"bar\"}]}"
    }
  }

  describe "get/3" do
    test "for JWK requests returns the keys from the account api" do
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

      assert Json.get(@authentication["account_jwk_uri"], :AccountAuthentication, name: "jwk") ==
               {:ok, %{"keys" => [%{"alg" => "foo", "kid" => "bar"}]}}
    end

    test "for IDCTA Config requests it returns the config from the api" do
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

      assert Json.get(@authentication["idcta_config_uri"], :AccountAuthentication, name: "idcta_config") ==
               {:ok, %{"id-availability" => "RED"}}
    end

    test "logs 200-status response" do
      HTTPMock |> expect(:execute, fn _, :AccountAuthentication -> @ok_response end)

      assert capture_log(fn -> Json.get(@authentication["account_jwk_uri"], :AccountAuthentication, name: "jwk") end) =~
               "jwk polled successfully"
    end

    test "logs non 200-status response" do
      HTTPMock |> expect(:execute, fn _, :AccountAuthentication -> @not_200_response end)

      assert capture_log(fn -> Json.get(@authentication["account_jwk_uri"], :AccountAuthentication, name: "jwk") end) =~
               "Non 200 Status Code (500) from jwk"
    end

    test "logs unknown response" do
      HTTPMock |> expect(:execute, fn _, :AccountAuthentication -> @unknown_response end)

      assert capture_log(fn -> Json.get(@authentication["account_jwk_uri"], :AccountAuthentication, name: "jwk") end) =~
               "Unknown response from jwk"
    end

    test "logs error response" do
      HTTPMock |> expect(:execute, fn _, :AccountAuthentication -> @error_response end)

      assert capture_log(fn -> Json.get(@authentication["account_jwk_uri"], :AccountAuthentication, name: "jwk") end) =~
               "Error received from jwk: timeout"
    end

    test "logs unknown http error" do
      HTTPMock |> expect(:execute, fn _, :AccountAuthentication -> @error_unknown_response end)

      assert capture_log(fn -> Json.get(@authentication["account_jwk_uri"], :AccountAuthentication, name: "jwk") end) =~
               "Unknown error received from jwk"
    end

    test "handles malformed JSON" do
      HTTPMock |> expect(:execute, fn _, :AccountAuthentication -> @malformed_json_response end)

      assert capture_log(fn -> Json.get(@authentication["account_jwk_uri"], :AccountAuthentication, name: "jwk") end) =~
               "Error while decoding data from jwk"
    end

    test "tracks the duration of the request" do
      stub(HTTPMock, :execute, fn _, :AccountAuthentication -> @ok_response end)

      metric =
        intercept_metric([:request, :jwk, :stop], fn ->
          Json.get(@authentication["account_jwk_uri"], :AccountAuthentication, name: "jwk")
        end)

      assert {_, %{duration: duration}, _} = metric
      assert duration > 0
    end
  end
end