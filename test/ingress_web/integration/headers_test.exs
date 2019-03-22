defmodule IngressWeb.Integration.HeadersTest do
  use ExUnit.Case
  use Plug.Test

  alias IngressWeb.Router
  alias Test.Support.StructHelper

  use Test.Support.Helper, :ingress_mox

  describe "content type headers" do
    def test_content_type!(body, content_type) do
      struct_with_response =
        StructHelper.build(
          response: %{
            body: body,
            headers: %{"content-type" => "#{content_type}; charset=utf-8"}
          }
        )

      IngressMock
      |> expect(:handle, fn _struct ->
        struct_with_response
      end)

      conn = conn(:get, "/_web_core")
      conn = Router.call(conn, [])

      assert ["#{content_type}; charset=utf-8"] == get_resp_header(conn, "content-type")
    end

    test "text/html" do
      test_content_type!("<p>some html content</p>", "text/html")
    end

    test "application/json" do
      test_content_type!(~s({"some": "json content"}), "application/json")
    end

    test "application/javascript" do
      test_content_type!("console.log(\"hey! I'm javascript\");", "application/javascript")
    end
  end
end
