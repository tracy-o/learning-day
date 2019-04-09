defmodule IngressWeb.WebCoreRoutesTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox

  alias Ingress.Struct
  alias Ingress.Struct.{Private, Request}
  alias IngressWeb.Router
  alias Test.Support.StructHelper

  describe "valid web core route with HTML response" do
    @struct_with_html_response StructHelper.build(
                                 response: %{
                                   body: "<p>Basic HTML response</p>",
                                   headers: %{"content-type" => "text/html; charset=utf-8"}
                                 }
                               )

    test "GET request to web core homepage" do
      IngressMock
      |> expect(:handle, fn %Struct{
                              private: %Private{loop_id: ["_web_core"]},
                              request: %Request{path: "/_web_core"}
                            } ->
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

    test "POST request to web core homepage" do
      IngressMock
      |> expect(:handle, fn
        %Struct{
          private: %Private{
            loop_id: ["_web_core"]
          },
          request: %Request{
            path: "/_web_core",
            payload: ~s({"query":"Some data please"})
          }
        } ->
          @struct_with_html_response
      end)

      conn = conn(:post, "/_web_core", ~s({"query":"Some data please"}))
      conn = Router.call(conn, [])

      assert {
               200,
               _headers,
               "<p>Basic HTML response</p>"
             } = sent_resp(conn)
    end
  end

  test "GET page-type request to web_core" do
    IngressMock
    |> expect(:handle, fn %Struct{
                            private: %Private{loop_id: ["_web_core", "page-type"]},
                            request: %Request{path: "/_web_core/page-type"}
                          } ->
      @struct_with_html_response
    end)

    conn = conn(:get, "/_web_core/page-type")
    conn = Router.call(conn, [])

    assert {
             200,
             _headers,
             "<p>Basic HTML response</p>"
           } = sent_resp(conn)
  end

  test "GET page-type with id request to web_core" do
    IngressMock
    |> expect(:handle, fn %Struct{
                            private: %Private{loop_id: ["_web_core", "page-type"]},
                            request: %Request{path: "/_web_core/page-type/123"}
                          } ->
      @struct_with_html_response
    end)

    conn = conn(:get, "/_web_core/page-type/123")
    conn = Router.call(conn, [])

    assert {
             200,
             _headers,
             "<p>Basic HTML response</p>"
           } = sent_resp(conn)
  end
end
