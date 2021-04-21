defmodule EndToEnd.SessionTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  alias BelfrageWeb.Router

  @moduletag :end_to_end

  setup do
    %{
      valid_access_token: Fixtures.AuthToken.valid_access_token(),
      invalid_access_token: Fixtures.AuthToken.invalid_access_token(),
      lambda_response: %{
        "headers" => %{
          "cache-control" => "private"
        },
        "statusCode" => 200,
        "body" => "<h1>Hello from the Lambda!</h1>"
      }
    }
  end

  test "when no authorization token is provided", %{lambda_response: lambda_response} do
    Belfrage.Clients.LambdaMock
    |> expect(:call, fn _role_arn, _function_arn, payload, _opts ->
      assert %{
               body: "",
               headers: %{
                 "accept-encoding": "gzip",
                 country: "gb",
                 host: "www.bbc.co.uk",
                 is_uk: false,
                 language: "en-GB"
               },
               httpMethod: "GET",
               path: "/my/session/webcore-platform",
               pathParameters: %{},
               queryStringParameters: %{}
             } == payload

      {:ok, lambda_response}
    end)

    response_conn = conn(:get, "/my/session/webcore-platform") |> Map.put(:host, "www.bbc.co.uk") |> Router.call([])

    assert {200, headers, body} = sent_resp(response_conn)
    assert {"cache-control", "private, stale-if-error=90, stale-while-revalidate=30"} in headers
    assert body == lambda_response["body"]
  end

  test "when a valid authorization token is provided", %{
    valid_access_token: access_token,
    lambda_response: lambda_response
  } do
    Belfrage.Clients.LambdaMock
    |> expect(:call, fn _role_arn, _function_arn, payload, _opts ->
      assert %{
               body: "",
               headers: %{
                 "accept-encoding": "gzip",
                 authorization: "Bearer #{access_token}",
                 "x-authentication-provider": "idv5",
                 "x-authentication-environment": "int",
                 country: "gb",
                 host: "www.bbc.co.uk",
                 is_uk: false,
                 language: "en-GB"
               },
               httpMethod: "GET",
               path: "/my/session/webcore-platform",
               pathParameters: %{},
               queryStringParameters: %{}
             } == payload

      {:ok, lambda_response}
    end)

    response_conn =
      conn(:get, "/my/session/webcore-platform")
      |> Map.put(:host, "www.bbc.co.uk")
      |> put_req_header("cookie", "ckns_atkn=#{access_token}")
      |> put_req_header("x-id-oidc-signedin", "1")
      |> Router.call([])

    assert {200, headers, body} = sent_resp(response_conn)
    assert {"cache-control", "private, stale-if-error=90, stale-while-revalidate=30"} in headers
    assert body == lambda_response["body"]
  end

  test "when an invalid authorization token is provided", %{
    invalid_access_token: access_token,
    lambda_response: lambda_response
  } do
    Belfrage.Clients.LambdaMock
    |> expect(:call, 0, fn _role_arn, _function_arn, _payload, _opts ->
      flunk("Lambda should not be called")
    end)

    response_conn =
      conn(:get, "/my/session/webcore-platform")
      |> Map.put(:host, "www.bbc.co.uk")
      |> put_req_header("cookie", "ckns_atkn=#{access_token}")
      |> put_req_header("x-id-oidc-signedin", "1")
      |> Router.call([])

    assert {302, headers, _body} = sent_resp(response_conn)

    assert {"location",
            "https://session.test.bbc.co.uk/session?ptrt=https%3A%2F%2Fwww.bbc.co.uk%2Fmy%2Fsession%2Fwebcore-platform"} in headers
  end
end
