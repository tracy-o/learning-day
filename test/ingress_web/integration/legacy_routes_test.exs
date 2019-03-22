defmodule IngressWeb.Integration.LegacyTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :ingress_mox

  alias Ingress.Struct
  alias Ingress.Struct.{Private, Request}
  alias IngressWeb.Router
  alias Test.Support.StructHelper

  describe "valid legacy route with HTML response" do
    @struct_with_html_response StructHelper.build(
                                 response: %{
                                   body: "<p>Basic HTML response</p>",
                                   headers: %{"content-type" => "text/html; charset=utf-8"}
                                 }
                               )

    test "GET request to legacy" do
      IngressMock
      |> expect(:handle, fn %Struct{
                              private: %Private{loop_id: ["_legacy"]},
                              request: %Request{path: "/_legacy"}
                            } ->
        @struct_with_html_response
      end)

      conn = conn(:get, "/_legacy")
      conn = Router.call(conn, [])

      assert {
               200,
               _headers,
               "<p>Basic HTML response</p>"
             } = sent_resp(conn)
    end

    test "POST reqeust to legacy" do
      IngressMock
      |> expect(:handle, fn %Struct{
                              private: %Private{loop_id: ["_legacy"]},
                              request: %Request{
                                path: "/_legacy",
                                payload: %{"query" => "some data please"}
                              }
                            } ->
        @struct_with_html_response
      end)

      conn = conn(:post, "/_legacy", %{"query" => "some data please"})
      conn = Router.call(conn, [])

      assert {
               200,
               _headers,
               "<p>Basic HTML response</p>"
             } = sent_resp(conn)
    end
  end
end
