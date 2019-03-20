defmodule Ingress.Services.LambdaTest do
  alias Ingress.Services.Lambda
  use ExUnit.Case

  import Mock


  describe "lambda service" do
    test "given a path it invokes the lambda" do
      with_mock InvokeLambda,
        [ invoke: fn _function_name, _options ->
          {200, %{"some_data" => "hello homepage"}} end ] do

        assert(
          Lambda.dispatch(%{request: %{path: "/"}}) ==
          %{request: %{path: "/"}, response: %{status: 200, body: %{"some_data" => "hello homepage"}}}
        )

        assert_called(
          InvokeLambda.invoke(
            "presentation-layer",
            %{
              instance_role_name: "ec2-role",
              function_payload: %{path: "/"},
              lambda_role_arn: "presentation-role"
            }
          )
        )
      end
    end

    test "given the lambda is down" do
      with_mock InvokeLambda,
        [ invoke: fn _function_name, _options ->
          {500, %{"error" => "Internal server error"}} end ] do

        assert(
          Lambda.dispatch(%{request: %{path: "/"}}) ==
          %{request: %{path: "/"}, response: %{status: 500, body: %{"error" => "Internal server error"}}}
        )

        assert_called(
          InvokeLambda.invoke(
            "presentation-layer",
            %{
              instance_role_name: "ec2-role",
              function_payload: %{path: "/"},
              lambda_role_arn: "presentation-role"
            }
          )
        )
      end
    end
  end
end