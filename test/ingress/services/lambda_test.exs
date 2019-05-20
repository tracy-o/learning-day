defmodule Ingress.Services.LambdaTest do
  alias Ingress.{LambdaClientMock, Struct}
  alias Ingress.Services.Lambda
  alias Test.Support.StructHelper

  use ExUnit.Case
  use Test.Support.Helper, :mox

  @struct StructHelper.build(
            private: %{origin: "https://www.bbc.co.uk"},
            request: %{payload: ~s({"some": "data"}), method: "POST"}
          )

  @struct_request @struct.request

  describe "lambda service" do
    test "given a path it invokes the lambda" do
      expect(LambdaClientMock, :call_lambda, fn _, _, _, @struct_request -> {200, "foobar"} end)

      assert %Struct{
               response: %Struct.Response{
                 http_status: 200,
                 body: "foobar"
               }
             } = Lambda.dispatch(@struct)
    end

    test "given the lambda is down" do
      expect(LambdaClientMock, :call_lambda, fn _, _, _, @struct_request ->
        {500, %{"error" => "Internal server error"}}
      end)

      assert %Struct{
               response: %Struct.Response{
                 http_status: 500,
                 body: %{"error" => "Internal server error"}
               }
             } = Lambda.dispatch(@struct)
    end
  end
end
