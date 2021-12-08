defmodule BelfrageWeb.ViewTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias BelfrageWeb.View
  alias Belfrage.Struct
  alias Belfrage.Struct.{Request, Response, Private}

  describe "render/2" do
    test "renders a successful binary response" do
      conn = render_response(%Response{http_status: 200, body: "OK"})
      assert conn.status == 200
      assert conn.resp_body == "OK"
    end

    test "renders a map as JSON response" do
      conn = render_response(%Response{http_status: 200, body: %{some: "json"}})
      assert conn.status == 200
      assert conn.resp_body == ~s({"some":"json"})
      assert get_resp_header(conn, "content-type") == ["application/json; charset=utf-8"]
    end

    test "renders an error from origin" do
      conn = render_response(%Response{http_status: 500, body: "ERROR"})
      assert conn.status == 500
      assert conn.resp_body == "ERROR"
    end

    test "sets response headers" do
      conn = render_response(%Response{http_status: 200, body: "OK", headers: %{"foo" => "bar"}})
      assert conn.status == 200
      assert conn.resp_body == "OK"
      assert get_resp_header(conn, "foo") == ["bar"]
    end

    test "ignores non-binary headers" do
      conn = render_response(%Response{http_status: 200, body: "OK", headers: %{"foo" => :bar}})
      assert conn.status == 200
      assert conn.resp_body == "OK"
      assert get_resp_header(conn, "foo") == []
    end

    test "sets Belfrage headers" do
      conn =
        render_response(%Struct{
          request: %Request{request_id: "request-id"},
          response: %Response{http_status: 200, body: "OK"}
        })

      assert conn.status == 200
      assert conn.resp_body == "OK"
      assert get_resp_header(conn, "brequestid") == ["request-id"]
    end

    test "renders redirects from origin" do
      conn = render_response(%Response{http_status: 301, body: "", headers: %{"location" => "http://example.com"}})
      assert conn.status == 301
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["http://example.com"]
    end

    test "renders default error page if response body is empty" do
      conn =
        render_response(%Struct{
          request: %Request{request_id: "request-id"},
          response: %Response{http_status: 500, body: nil}
        })

      assert conn.status == 500
      assert conn.resp_body == "<h1>500 Internal Server Error</h1>\n<!-- Belfrage -->"
      assert get_resp_header(conn, "brequestid") == ["request-id"]
    end

    test "renders default error page as publicly cacheable if request is not personalised" do
      conn =
        render_response(%Struct{
          response: %Response{http_status: 500, body: nil},
          private: %Private{personalised_request: false}
        })

      assert conn.status == 500
      assert get_resp_header(conn, "cache-control") == ["public, stale-while-revalidate=15, max-age=5"]
    end

    test "renders default error page as privately cacheable if request is personalised" do
      conn =
        render_response(%Struct{
          response: %Response{http_status: 500, body: nil},
          private: %Private{personalised_request: true}
        })

      assert conn.status == 500
      assert get_resp_header(conn, "cache-control") == ["private, stale-while-revalidate=15, max-age=0"]
    end

    defp render_response(response = %Response{}) do
      render_response(%Struct{response: response})
    end

    defp render_response(struct = %Struct{}) do
      View.render(struct, build_conn())
    end
  end

  describe "redirect/4" do
    test "returns a redirect" do
      conn = redirect(301, "http://example.com")
      assert conn.status == 301
      assert get_resp_header(conn, "location") == ["http://example.com"]
    end

    test "returns error 400 if location header contains a new line" do
      conn = redirect(301, "http://example.com\n")
      assert conn.status == 400
      assert conn.resp_body == "<h1>400</h1>\n<!-- Belfrage -->"
      assert get_resp_header(conn, "location") == []
    end

    defp redirect(status, location) do
      View.redirect(%Struct{}, build_conn(), status, location)
    end
  end

  test "not_found/1" do
    conn = build_conn() |> View.not_found()
    assert conn.status == 404
    assert conn.resp_body == "<h1>404 Page Not Found</h1>\n<!-- Belfrage -->"

    assert get_resp_header(conn, "cache-control") == [
             "public, stale-if-error=90, stale-while-revalidate=60, max-age=30"
           ]
  end

  test "internal_server_error/1" do
    conn = build_conn() |> View.internal_server_error()
    assert conn.status == 500
    assert conn.resp_body == "<h1>500 Internal Server Error</h1>\n<!-- Belfrage -->"
    assert get_resp_header(conn, "cache-control") == ["public, stale-while-revalidate=15, max-age=5"]
  end

  test "unsupported_method/1" do
    conn = build_conn() |> View.unsupported_method()
    assert conn.status == 405
    assert conn.resp_body == "<h1>405 Not Supported</h1>\n<!-- Belfrage -->"
    assert get_resp_header(conn, "cache-control") == ["public, stale-while-revalidate=15, max-age=5"]
  end

  defp build_conn() do
    conn(:get, "/_web_core")
  end
end
