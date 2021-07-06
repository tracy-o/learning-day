defmodule EndToEnd.DistributedTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  use Test.Support.Helper, :mox

  @moduletag :end_to_end

  setup do
    :ets.delete_all_objects(:cache)

    %{
      cacheable_lambda_response: %{
        "headers" => %{
          "cache-control" => "public, max-age=30"
        },
        "statusCode" => 200,
        "body" => "<h1>Hello from the Lambda!</h1>"
      },
      failed_lambda_response: %{
        "headers" => %{
          "cache-control" => "public, max-age=30"
        },
        "statusCode" => 500,
        "body" => "<h1>Hello from the Lambda!</h1>"
      },
      un_cacheable_lambda_response: %{
        "headers" => %{
          "cache-control" => "private, max-age=30"
        },
        "statusCode" => 200,
        "body" => "<h1>Hello from the Lambda!</h1>"
      }
    }
  end

  describe "public responses" do
    test "saves page to belfrage-ccp", %{cacheable_lambda_response: cacheable_lambda_response} do
      test_pid = self()

      Belfrage.Clients.LambdaMock
      |> expect(:call, fn _role_arn, _lambda_function, _payload, _request_id, _opts ->
        {:ok, cacheable_lambda_response}
      end)

      Belfrage.Clients.CCPMock
      |> expect(:put, fn %Belfrage.Struct{} = struct ->
        send(test_pid, {:ccp_request_hash_stored, struct.request.request_hash})

        :ok
      end)

      conn = conn(:get, "/200-ok-response?belfrage-cache-bust") |> Router.call([])
      assert [request_hash] = get_resp_header(conn, "bsig")

      assert_received({:ccp_request_hash_stored, ^request_hash})
    end
  end

  describe "private responses" do
    test "does NOT save a page to belfrage-ccp", %{un_cacheable_lambda_response: un_cacheable_lambda_response} do
      Belfrage.Clients.LambdaMock
      |> expect(:call, fn _role_arn, _lambda_function, _payload, _request_id, _opts ->
        {:ok, un_cacheable_lambda_response}
      end)

      Belfrage.Clients.CCPMock
      |> expect(:put, 0, fn _struct ->
        flunk("Should not call the ccp.")
      end)

      conn(:get, "/200-ok-response?belfrage-cache-bust") |> Router.call([])
    end
  end

  describe "failed responses" do
    test "does NOT save a page to belfrage-ccp", %{failed_lambda_response: failed_lambda_response} do
      Belfrage.Clients.LambdaMock
      |> expect(:call, fn _role_arn, _lambda_function, _payload, _request_id, _opts ->
        {:ok, failed_lambda_response}
      end)

      Belfrage.Clients.CCPMock
      |> expect(:put, 0, fn _struct ->
        flunk("Should not call the ccp.")
      end)

      conn(:get, "/200-ok-response?belfrage-cache-bust") 
      |> Router.call([])
    end
  end
end
