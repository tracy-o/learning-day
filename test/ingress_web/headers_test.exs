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

    def make_404_call(body, headers = %{}, path) do
      conn = conn(:get, path)
      Router.call(conn, [])
    end

    def make_500_call(_body, headers = %{}, path) do
      IngressMock
      |> expect(:handle, fn _ ->
        raise("Something broke")
      end)

      conn = conn(:get, path)

      assert_raise Plug.Conn.WrapperError, "** (RuntimeError) Something broke", fn ->
        Router.call(conn, [])
      end

      conn
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
    test "with a valid path default response_headers are added" do
      conn =
        make_call(
          "<p>some html content</p>",
          %{"content-type" => "text/html; charset=utf-8"},
          "/_web_core"
        )

      assert {200,
              [
                {"cache-control", "public, stale-while-revalidate=10, max-age=30"},
                {"content-type", "text/html; charset=utf-8"},
                {"vary", "Accept-Encoding, X-BBC-Edge-Cache, X-BBC-Edge-Country"}
              ], "<p>some html content</p>"} == sent_resp(conn)
    end

    test "with a 404 path default response_headers are added" do
      conn = make_404_call("<p>some html content</p>", %{}, "/_non_existing_path")

      assert {404,
              [
                {"cache-control", "public, stale-while-revalidate=10, max-age=5"},
                {"vary", "Accept-Encoding, X-BBC-Edge-Cache, X-BBC-Edge-Country"},
                {"content-type", "text/plain; charset=utf-8"}
              ], "404 Not Found"} == sent_resp(conn)
    end

    test "with a 500 path default response_headers are added" do
      conn = make_500_call("<p>some html content</p>", %{}, "/_web_core")

      assert {500,
              [
                {"cache-control", "public, stale-while-revalidate=10, max-age=5"},
                {"vary", "Accept-Encoding, X-BBC-Edge-Cache, X-BBC-Edge-Country"},
                {"content-type", "text/plain; charset=utf-8"}
              ], "500 Internal Server Error"} = sent_resp(conn)
    end
  end
end
