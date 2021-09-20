defmodule EndToEnd.PersonalisationInCascade do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  import Belfrage.Test.PersonalisationHelper

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
    |> expect(:call, fn _role_arn, _function_arn, payload, _request_id, _opts ->
      assert "Bearer #{access_token}" == get_in(payload, [:headers, :authorization])
      assert "idv5" == get_in(payload, [:headers, :"x-authentication-provider"])

      {:ok, lambda_response}
    end)

    Belfrage.Clients.HTTPMock
    |> expect(:execute, fn request, :MozartNews ->
      assert Enum.all?(request.headers, &is_binary(elem(&1, 0))),
             "Expects all header keys to be binaries for following assertions."

      refute Map.has_key?(request.headers, "authorization")
      refute Map.has_key?(request.headers, "x-authentication-provider")

      {:ok, mozart_response}
    end)

    conn(:get, "/personalisation-in-cascade")
    |> Map.put(:host, "www.bbc.co.uk")
    |> personalise_request(access_token)
    |> Router.call([])
  end
end
