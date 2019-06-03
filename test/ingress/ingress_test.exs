defmodule IngressTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox

  alias Ingress.Struct
  alias Ingress.Clients.LambdaMock
  alias Test.Support.StructHelper

  @get_request_struct StructHelper.build(
                        private: %{
                          loop_id: ["test_loop"]
                        },
                        request: %{
                          path: "/_web_core",
                          method: "GET",
                          country: "gb"
                        }
                      )

  @post_request_struct StructHelper.build(
                         request: %{
                           method: "POST",
                           payload: ~s({"some": "data please"}),
                           country: "gb"
                         },
                         private: %{
                           loop_id: ["test_loop"]
                         }
                       )

  @web_core_lambda_response {:ok,
                             %{"body" => "Some content", "headers" => %{}, "statusCode" => 200}}

  test "GET request invokes lambda service with WebCoreLambda transformer" do
    LambdaMock
    |> expect(:call, fn "ec2-role",
                        "presentation-role",
                        "presentation-layer",
                        %{body: nil, headers: %{country: "gb"}, httpMethod: "GET"} ->
      @web_core_lambda_response
    end)

    Ingress.handle(@get_request_struct)
  end

  test "POST request invokes lambda service with WebCoreLambda transformer" do
    LambdaMock
    |> expect(:call, fn "ec2-role",
                        "presentation-role",
                        "presentation-layer",
                        %{
                          body: ~s({"some": "data please"}),
                          headers: %{country: "gb"},
                          httpMethod: "POST"
                        } ->
      @web_core_lambda_response
    end)

    Ingress.handle(@post_request_struct)
  end
end
