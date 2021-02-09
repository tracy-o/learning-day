defmodule EndToEnd.PersonalisationInCascade do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  alias BelfrageWeb.Router

  setup do
    %{
      valid_access_token: Fixtures.AuthToken.valid_access_token(),
      lambda_response: %{
        "headers" => %{
          "cache-control" => "private"
        },
        "statusCode" => 404,
        "body" => "<h1>Hello from the Lambda!</h1>"
      },
      mozart_response: %Belfrage.Clients.HTTP.Response{
        status_code: 404,
        body: "<h1>Hello from Mozart!</h1>",
        headers: %{
          "cache-control" => "private"
        }
      }
    }
  end

  test "when valid auth token is provided, auth token is only sent to personalised renderers", %{
    valid_access_token: access_token,
    lambda_response: lambda_response,
    mozart_response: mozart_response
  } do
    Belfrage.Clients.LambdaMock
    |> expect(:call, fn _role_arn, _function_arn, payload, _opts ->
      assert %{
               body: "",
               headers: %{
                 "accept-encoding": "gzip",
                 authorization: "Bearer #{access_token}",
                 country: "gb",
                 host: "www.bbc.co.uk",
                 is_uk: false,
                 language: "en-GB",
                 "x-authentication-provider": "idv5"
               },
               httpMethod: "GET",
               path: "/personalisation-in-cascade",
               pathParameters: %{},
               queryStringParameters: %{}
             } == payload

      {:ok, lambda_response}
    end)

    Belfrage.Clients.HTTPMock
    |> expect(:execute, fn request ->
      assert %{
               "accept-encoding" => "gzip",
               "req-svc-chain" => "BELFRAGE",
               "user-agent" => "Belfrage",
               "x-country" => "gb",
               "x-forwarded-host" => "www.bbc.co.uk"
             } == request.headers

      {:ok, mozart_response}
    end)

    conn(:get, "/personalisation-in-cascade")
    |> Map.put(:host, "www.bbc.co.uk")
    |> put_req_header("cookie", "ckns_atkn=#{access_token}")
    |> put_req_header("x-id-oidc-signedin", "1")
    |> Router.call([])
  end
end
