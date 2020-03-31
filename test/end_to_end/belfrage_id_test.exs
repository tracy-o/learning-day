defmodule BelfrageWeb.ResponseHeaders.BelfrageIDTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  use Test.Support.Helper, :mox

  @moduletag :end_to_end

  @lambda_response %{
    "headers" => %{
      "cache-control" => "public, max-age=30"
    },
    "statusCode" => 200,
    "body" => "<h1>Hello from the Lambda!</h1>"
  }

  describe "when the stack_id is www" do
    test "returns the bid header with a value of www" do
      Application.put_env(:belfrage, :stack_id, "www")

      Belfrage.Clients.LambdaMock
      |> expect(:call, fn _lambda_name, _role_arn, _payload, _opts ->
        {:ok, @lambda_response}
      end)

      response_conn = conn(:get, "/") |> Router.call([])

      assert {200, resp_headers, _body} = sent_resp(response_conn)
      assert {"bid", "www"} in resp_headers

      Application.put_env(:belfrage, :stack_id, "local")
    end
  end
end
