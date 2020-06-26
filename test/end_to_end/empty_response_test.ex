defmodule BelfrageWeb.EmptyErrorResponseTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  use Test.Support.Helper, :mox

  @moduletag :end_to_end

  @lambda_response %{
    "headers" => %{
      "content-length" => "0"
    },
    "statusCode" => 404,
    "body" => ""
  }

  test "returns a Belfrage internal response" do
    Belfrage.Clients.LambdaMock
    |> expect(:call, fn _lambda_name, _role_arn, _payload, _opts ->
      {:ok, @lambda_response}
    end)

    response_conn = conn(:get, "/downstream-not-found") |> Router.call([])

    assert {404, resp_headers, "<h1>404 Error Page</h1>\n<!-- Belfrage -->"} = sent_resp(response_conn)
  end
end
