defmodule IngressTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox

  alias Ingress.Struct
  alias Ingress.Services.ServiceMock
  alias Test.Support.StructHelper

  @get_request_struct StructHelper.build(
                        private: %{
                          loop_id: ["test_loop"]
                        },
                        request: %{
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

  @struct_with_html_response StructHelper.build(
                               response: %{
                                 body: "<p>Basic HTML response</p>",
                                 headers: %{"content-type" => "text/html; charset=utf-8"},
                                 http_status: 200,
                                 cacheable_content: false
                               }
                             )

  test "GET request invokes lambda service with WebCoreLambda transformer" do
    ServiceMock
    |> expect(:dispatch, fn %Struct{
                              private: %Struct.Private{loop_id: ["test_loop"]},
                              request: %Struct.Request{
                                path: "/_web_core",
                                method: "GET",
                                country: "gb"
                              }
                            } ->
      @struct_with_html_response
    end)

    Ingress.handle(@get_request_struct)
  end

  test "POST request invokes lambda service with WebCoreLambda transformer" do
    ServiceMock
    |> expect(:dispatch, fn %Struct{
                              private: %Struct.Private{loop_id: ["test_loop"]},
                              request: %Struct.Request{
                                path: "/_web_core",
                                payload: ~s({"some": "data please"}),
                                method: "POST",
                                country: "gb"
                              }
                            } ->
      @struct_with_html_response
    end)

    Ingress.handle(@post_request_struct)
  end
end
