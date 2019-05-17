defmodule Ingress.Services.LambdaTest do
  # alias Ingress.LambdaClientMock
  alias Ingress.Services.Lambda
  alias Test.Support.StructHelper

  alias Ingress.Struct

  use ExUnit.Case
  # use Test.Support.Helper, :mox

  @struct StructHelper.build()

  describe "lambda service" do
    test "given a path it invokes the lambda" do
      
      # |> expect(:request, "foo", "bar")
      # expect(LambdaClientMock, :request, fn "foo", "bar" -> true end)
      assert Lambda.dispatch(@struct) == true




      # with_mock ExAws.Lambda,
      #   invoke: fn _function_name, _payload, _context ->
      #     {200, %{"some_data" => "hello homepage"}}
      #   end do
      #   assert %{
      #            response: %Struct.Response{
      #              http_status: 200,
      #              body: %{"some_data" => "hello homepage"}
      #            }
      #          } = Lambda.dispatch(@struct)

        # assert_called(
        #   ExAws.Lambda.invoke(
        #     "presentation-layer",
        #     %{
        #       instance_role_name: "ec2-role",
        #       function_payload: %Struct.Request{path: "/_web_core", method: "GET", payload: nil},
        #       lambda_role_arn: "presentation-role"
        #     }
        #   )
        # )
      # end
    end

    # test "given the lambda is down" do
    #   with_mock InvokeLambda,
    #     invoke: fn _function_name, _payload, _context ->
    #       {500, %{"error" => "Internal server error"}}
    #     end do
    #     assert %{
    #              response: %Ingress.Struct.Response{
    #                http_status: 500,
    #                body: %{"error" => "Internal server error"}
    #              }
    #            } = Lambda.dispatch(@struct)

    #     assert_called(
    #       InvokeLambda.invoke(
    #         "presentation-layer",
    #         %{
    #           instance_role_name: "ec2-role",
    #           function_payload: %{path: "/_web_core"},
    #           lambda_role_arn: "presentation-role"
    #         }
    #       )
    #     )
    #   end
    # end
  end
end
