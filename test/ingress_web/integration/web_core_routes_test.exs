defmodule IngressWeb.Integration.WebCoreRoutesTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :ingress_mox

  alias Ingress.Struct
  alias IngressWeb.Router
  alias Test.Support.StructHelper

  describe "valid web core route with HTML response" do
    @struct_with_html_response StructHelper.build(response: %{
      body: "<p>Basic HTML response</p>",
      headers: %{"content-type" => "text/html; charset=utf-8"}
    })

    test "GET request to web core" do
      IngressMock
      |> expect(:handle, fn {"_web_core", %Struct{request: %Struct.Request{path: "/_web_core"}}} ->
        @struct_with_html_response
      end)

      conn = conn(:get, "/_web_core")
      conn = Router.call(conn, [])

      assert {
               200,
               _headers,
               "<p>Basic HTML response</p>"
             } = sent_resp(conn)
    end

    test "POST request to web core" do
      IngressMock
      |> expect(:handle, fn {"_web_core",
                             %Struct{
                               request: %Struct.Request{
                                 path: "/_web_core",
                                 payload: %{"query" => "Some data please"}
                               }
                             }} ->
        @struct_with_html_response
      end)

      conn = conn(:post, "/_web_core", %{"query" => "Some data please"})
      conn = Router.call(conn, [])

      assert {
               200,
               _headers,
               "<p>Basic HTML response</p>"
             } = sent_resp(conn)
    end
  end
end
