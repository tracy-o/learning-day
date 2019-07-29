defmodule Belfrage.Clients.LambdaTest do
  alias Belfrage.Clients.Lambda
  use ExUnit.Case
  use Test.Support.Helper, :mox

  describe "Belfrage.Clients.Lambda.call/3" do
    test "Given a working function name, role arn, and payload it authenticates and calls the lambda and returns the response" do
      assert Lambda.call("webcore-lambda-role-arn", "pwa-lambda-function", %{some: "data"}) ==
               {:ok, "<h1>A Page</h1>"}
    end

    test "Given a role we cannot assume we return the :failed_to_assume_role error" do
      assert Lambda.call("the-wrong-role", "presentation-lambda", %{some: "data"}) ==
               {:error, :credentials_not_found_in_cache}
    end

    test "Given a working role, but an incorrect function name we return the :failed_to_invoke_lambda error" do
      assert Lambda.call("webcore-lambda-role-arn", "not-a-real-lambda", %{some: "data"}) ==
               {:error, :failed_to_invoke_lambda}
    end
  end

  describe "Belfrage.Clients.Lambda.build_options/1" do
    test "combines default and passed in options if keys are unique" do
      assert Lambda.build_options(timeout: 1000) == [
               protocols: [:http2, :http1],
               pool: false,
               timeout: 1000
             ]
    end

    test "overwrites ExAws values if the same option is passed" do
      assert Lambda.build_options(protocols: [:http2], pool: true) == [
               protocols: [:http2, :http1],
               pool: false,
               timeout: 1000
             ]
    end
  end

  describe "ExAWS request callback" do
    @generic_response {:ok,
                       %Mojito.Response{
                         status_code: 200,
                         headers: [{"content-type", "application/json"}],
                         body: "{}"
                       }}

    test "Lambda request function uses http client to send POST" do
      Belfrage.Clients.HTTPMock
      |> expect(:request, fn :post,
                             "https://www.example.com/foo",
                             ~s({"some": "data"}),
                             [headers: [], protocols: [:http2, :http1], pool: false, timeout: 1000] ->
        @generic_response
      end)

      Lambda.request(:post, "https://www.example.com/foo", ~s({"some": "data"}))
    end

    test "Lambda request function does pass through query strings" do
      Belfrage.Clients.HTTPMock
      |> expect(:request, fn :post,
                             "https://www.example.com/foo?some-qs=hello",
                             ~s({"some": "data"}),
                             [headers: [], protocols: [:http2, :http1], pool: false, timeout: 1000] ->
        @generic_response
      end)

      Lambda.request(:post, "https://www.example.com/foo?some-qs=hello", ~s({"some": "data"}))
    end

    test "Lambda request handles get" do
      Belfrage.Clients.HTTPMock
      |> expect(:request, fn :get,
                             "https://www.example.com/foo?some-qs=hello",
                             "",
                             [headers: [], protocols: [:http2, :http1], pool: false, timeout: 1000] ->
        @generic_response
      end)

      Lambda.request(:get, "https://www.example.com/foo?some-qs=hello")
    end
  end
end
