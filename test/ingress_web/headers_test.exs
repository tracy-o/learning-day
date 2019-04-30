defmodule IngressWeb.HeadersTest do
  use ExUnit.Case
  use Plug.Test

  alias IngressWeb.Router
  alias Test.Support.StructHelper

  use Test.Support.Helper, :mox

  describe "content type response_headers" do
    def make_call(body, headers = %{}, path) do
      struct_with_response =
        StructHelper.build(
          response: %{
            body: body,
            headers: headers
          }
        )

      IngressMock
      |> expect(:handle, fn _struct ->
        struct_with_response
      end)

      conn = conn(:get, path)
      Router.call(conn, [])
    end

    def test_content_type!(body, content_type) do
      conn = make_call(body, %{"content-type" => "#{content_type}; charset=utf-8"}, "/_web_core")

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

  defp get_header_keys(conn) do
    Enum.map(conn.resp_headers, fn header_tuple -> elem(header_tuple, 0) end)
  end

  describe "default response_headers" do
    test "default response_headers are added" do
      conn = make_call("<p>some html content</p>", %{}, "/_web_core")

      assert ["cache-control", "vary"] == get_header_keys(conn)
    end
  end
end
