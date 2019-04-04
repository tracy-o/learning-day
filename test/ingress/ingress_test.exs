defmodule IngressTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox

  alias Ingress.Struct
  alias Ingress.Services.ServiceMock
  alias Test.Support.StructHelper

  @initial_struct StructHelper.build(
                    private: %{
                      loop_id: ["test_loop"]
                    }
                  )

  @struct_with_html_response StructHelper.build(
                               response: %{
                                 body: "<p>Basic HTML response</p>",
                                 headers: %{"content-type" => "text/html; charset=utf-8"}
                               }
                             )

  test "invokes lambda service after WebCoreLambda transformer" do
    ServiceMock
    |> expect(:dispatch, fn %Struct{
                              private: %Struct.Private{loop_id: ["test_loop"]},
                              request: %Struct.Request{
                                path: "/_web_core",
                                payload: %{
                                  path: "/_web_core",
                                  payload: nil
                                }
                              }
                            } ->
      @struct_with_html_response
    end)

    Ingress.handle(@initial_struct)
  end
end
