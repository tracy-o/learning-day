defmodule IngressTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox

  alias Ingress.Struct
  alias Ingress.Services.LambdaMock
  alias Test.Support.StructHelper

  @get_request_struct StructHelper.build(
                        private: %{
                          loop_id: "test_loop"
                        }
                      )

  @post_request_struct StructHelper.build(
                         request: %{
                           method: "POST",
                           payload: ~s({"some": "data please"})
                         },
                         private: %{
                           loop_id: "test_loop"
                         }
                       )

  @struct_with_html_response StructHelper.build(
                               response: %{
                                 body: "<p>Basic HTML response</p>",
                                 headers: %{"content-type" => "text/html; charset=utf-8"}
                               }
                             )

  test "GET request invokes lambda service with WebCoreLambda transformer" do
    LambdaMock
    |> expect(:dispatch, fn %Struct{
                              private: %Struct.Private{loop_id: "test_loop"},
                              request: %Struct.Request{
                                path: "/_web_core",
                                method: "GET"
                              }
                            } ->
      @struct_with_html_response
    end)

    Ingress.handle(@get_request_struct)
  end

  test "POST request invokes lambda service with WebCoreLambda transformer" do
    LambdaMock
    |> expect(:dispatch, fn %Struct{
                              private: %Struct.Private{loop_id: "test_loop"},
                              request: %Struct.Request{
                                path: "/_web_core",
                                payload: ~s({"some": "data please"}),
                                method: "POST"
                              }
                            } ->
      @struct_with_html_response
    end)

    Ingress.handle(@post_request_struct)
  end
end
