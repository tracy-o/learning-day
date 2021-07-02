defmodule BelfrageWeb.EmptyErrorResponseTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  use Test.Support.Helper, :mox

  @moduletag :end_to_end

  setup do
    %{
      lambda_response: %{
        "headers" => %{
          "content-length" => 0
        },
        "statusCode" => 200,
        "body" => ""
      }
    }
  end

  describe "returns a Belfrage internal response" do
    test "when response status code is 404", %{lambda_response: lambda_response} do
      Belfrage.Clients.LambdaMock
      |> expect(:call, fn _lambda_name, _role_arn, _payload, _request_id, _opts ->
        {:ok, Map.put(lambda_response, "statusCode", 404)}
      end)

      response_conn =
        conn(:get, "/downstream-not-found") |> put_req_header("accept-encoding", "gzip") |> Router.call([])

      assert {404, resp_headers, "<h1>404 Error Page</h1>\n<!-- Belfrage -->"} = sent_resp(response_conn)
    end

    test "when response status code is 400", %{lambda_response: lambda_response} do
      Belfrage.Clients.LambdaMock
      |> expect(:call, fn _lambda_name, _role_arn, _payload, _request_id, _opts ->
        {:ok, Map.put(lambda_response, "statusCode", 400)}
      end)

      response_conn =
        conn(:get, "/downstream-not-found") |> put_req_header("accept-encoding", "gzip") |> Router.call([])

      assert {400, resp_headers, "<h1>400</h1>\n<!-- Belfrage -->"} = sent_resp(response_conn)
    end
  end
end
