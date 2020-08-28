defmodule BelfrageWeb.ViewTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox

  alias BelfrageWeb.View
  alias Belfrage.Struct

  @json_codec Application.get_env(:belfrage, :json_codec)

  doctest View

  defp build_struct_and_render(body) do
    %Struct{response: %Struct.Response{body: body, http_status: 200}}
    |> View.render(conn(:get, "/_web_core"))
    |> sent_resp()
  end

  test "Rendering response from a struct with a 200 HTML response" do
    {status, _headers, body} = build_struct_and_render("<p>Basic HTML response</p>")

    assert status == 200
    assert body == "<p>Basic HTML response</p>"
  end

  test "Rendering response from a struct with a 200 Map response" do
    {status, _headers, body} = build_struct_and_render(%{some: "json data"})

    assert status == 200
    assert body == @json_codec.encode!(%{some: "json data"})
  end

  test "ignores non-string header values when building response headers for the conn" do
    struct = %Struct{
      response: %Struct.Response{
        body: "<p>hi</p>",
        http_status: 200,
        headers: %{"non-string" => true, "string" => "true"}
      }
    }

    conn = conn(:get, "/_web_core")
    {_status, headers, _body} = View.render(struct, conn) |> sent_resp()
    assert {"string", "true"} in headers
    refute {"non-string", true} in headers
  end

  describe "when content-length is 0" do
    test "returns HTML 500 page" do
      struct = %Struct{
        response: %Struct.Response{
          body: "",
          http_status: 500,
          headers: %{"content-length" => "0"}
        }
      }

      conn = conn(:get, "/") |> put_req_header("accept", "text/html")
      {status, headers, body} = View.render(struct, conn) |> sent_resp()
      assert status == 500
      assert body == "content for file test/support/resources/internal-error.html<!-- Belfrage -->"
      assert {"content-type", "text/html; charset=utf-8"} in headers
    end

    test "returns HTML 404 page" do
      struct = %Struct{
        response: %Struct.Response{
          body: "",
          http_status: 404,
          headers: %{"content-length" => "0"}
        }
      }

      conn = conn(:get, "/") |> put_req_header("accept", "text/html")
      {status, headers, body} = View.render(struct, conn) |> sent_resp()
      assert status == 404
      assert body == "content for file test/support/resources/not-found.html<!-- Belfrage -->"
      assert {"content-type", "text/html; charset=utf-8"} in headers
    end

    test "returns JSON error content" do
      struct = %Struct{
        response: %Struct.Response{
          body: "",
          http_status: 500,
          headers: %{"content-length" => "0"}
        }
      }

      conn = conn(:get, "/") |> put_req_header("accept", "application/json")
      {status, headers, body} = View.render(struct, conn) |> sent_resp()
      assert status == 500
      assert body == ~s({"status":500})
      assert {"content-type", "application/json"} in headers
    end

    test "returns plain text error content" do
      struct = %Struct{
        response: %Struct.Response{
          body: "",
          http_status: 500,
          headers: %{"content-length" => "0"}
        }
      }

      conn = conn(:get, "/") |> put_req_header("accept", "text/plain")
      {status, headers, body} = View.render(struct, conn) |> sent_resp()
      assert status == 500
      assert body == "500, Belfrage"
      assert {"content-type", "text/plain"} in headers
    end

    test "continue rendering response struct, when status code is bellow 400" do
      struct = %Struct{
        response: %Struct.Response{
          body: "",
          http_status: 302,
          headers: %{"content-length" => "0", "content-type" => "text/plain"}
        }
      }

      conn = conn(:get, "/") |> put_req_header("accept", "text/plain")
      {status, headers, body} = View.render(struct, conn) |> sent_resp()
      assert status == 302
      assert body == ""
      assert {"content-type", "text/plain"} in headers
    end
  end

  describe "fallback page response header" do
    test "when response is a fallback page" do
      struct = %Struct{
        response: %Struct.Response{
          body: "<p>hi</p>",
          http_status: 200,
          headers: %{},
          fallback: true
        }
      }

      conn = conn(:get, "/_web_core")
      {_status, headers, _body} = View.render(struct, conn) |> sent_resp()
      assert {"belfrage-cache-status", "STALE"} in headers
    end

    test "when response is not a fallback page" do
      struct = %Struct{
        response: %Struct.Response{
          body: "<p>hi</p>",
          http_status: 200,
          headers: %{},
          fallback: false
        }
      }

      conn = conn(:get, "/_web_core")
      {_status, headers, _body} = View.render(struct, conn) |> sent_resp()
      refute {"belfrage-cache-status", "STALE"} in headers
    end
  end

  describe "error pages" do
    @not_found_page Application.get_env(:belfrage, :not_found_page)
    @internal_error_page Application.get_env(:belfrage, :internal_error_page)

    test "Rendering response from a struct with a 200 and a nil response" do
      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn @internal_error_page -> {:ok, "<h1>500 Error Page</h1>\n"} end)

      {status, _headers, body} = build_struct_and_render(nil)

      assert status == 500
      assert body == "<h1>500 Error Page</h1>\n<!-- Belfrage -->"
    end

    test "serving the BBC standard error page for a 500 status" do
      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn @internal_error_page -> {:ok, "<h1>500 Error Page</h1>\n"} end)

      {status, _headers, body} =
        conn(:get, "/_web_core")
        |> View.internal_server_error()
        |> sent_resp()

      assert status == 500
      assert body == "<h1>500 Error Page</h1>\n<!-- Belfrage -->"
    end

    test "serving the BBC standard error page for a 404 status" do
      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn @not_found_page -> {:ok, "<h1>404 Error Page</h1>\n"} end)

      {status, _headers, body} =
        conn(:get, "/_web_core")
        |> View.not_found()
        |> sent_resp()

      assert status == 404
      assert body == "<h1>404 Error Page</h1>\n<!-- Belfrage -->"
    end

    test "when the BBC standard error page for a 404 does not exist it serves a default error body" do
      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn @not_found_page -> {:error, ~s()} end)

      {status, _headers, body} =
        conn(:get, "/_web_core")
        |> View.not_found()
        |> sent_resp()

      assert status == 404
      assert body == "<h1>404 Page Not Found</h1>\n<!-- Belfrage -->"
    end

    test "when the BBC standard error page for a 500 does not exist it serves a default error body" do
      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn @internal_error_page -> {:error, ~s()} end)

      {status, _headers, body} =
        conn(:get, "/_web_core")
        |> View.internal_server_error()
        |> sent_resp()

      assert status == 500
      assert body == "<h1>500 Internal Server Error</h1>\n<!-- Belfrage -->"
    end
  end
end
