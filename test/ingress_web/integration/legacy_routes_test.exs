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

    test "GET homepage request to legacy" do
      IngressMock
      |> expect(:handle, fn %Struct{
                              private: %Private{loop_id: ["legacy"]},
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

    test "GET page-type request to legacy" do
      IngressMock
      |> expect(:handle, fn %Struct{
                              private: %Private{loop_id: ["legacy", "page_type"]},
                              request: %Request{path: "/_legacy/page-type"}
                            } ->
        @struct_with_html_response
      end)

      conn = conn(:get, "/_legacy/page-type")
      conn = Router.call(conn, [])

      assert {
               200,
               _headers,
               "<p>Basic HTML response</p>"
             } = sent_resp(conn)
    end

    test "GET page-type with id request to legacy" do
      IngressMock
      |> expect(:handle, fn %Struct{
                              private: %Private{loop_id: ["legacy", "page_type_with_id"]},
                              request: %Request{path: "/_legacy/page-type/123"}
                            } ->
        @struct_with_html_response
      end)

      conn = conn(:get, "/_legacy/page-type/123")
      conn = Router.call(conn, [])

      assert {
               200,
               _headers,
               "<p>Basic HTML response</p>"
             } = sent_resp(conn)
    end

    test "POST homepage reqeust to legacy" do
      IngressMock
      |> expect(:handle, fn %Struct{
                              private: %Private{loop_id: ["legacy"]},
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
