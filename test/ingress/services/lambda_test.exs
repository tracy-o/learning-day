defmodule Ingress.Services.LambdaTest do
  alias Ingress.Services.Lambda
  use ExUnit.Case

  import Mock


  describe "lambda service" do
    test "given a path it invokes the lambda" do
      with_mock InvokeLambda,
        [ invoke: fn _function_name, _options ->
          {200, %{"body" => "hello homepage"}} end ] do

        Lambda.dispatch(%{request: %{path: "/"}})

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