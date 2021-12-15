defmodule BelfrageWeb.Response.InternalTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias BelfrageWeb.Response.Internal
  alias Belfrage.{Struct, CacheControl}
  alias Belfrage.Struct.{Response, Private}

  test "html requested" do
    response = build_response(404, request_headers: %{"accept" => "text/html"})
    assert response.headers["content-type"] == "text/html; charset=utf-8"
  end

  test "json requested" do
    response = build_response(404, request_headers: %{"accept" => "application/json"})
    assert response.headers["content-type"] == "application/json"
    assert response.body == ~s({"status":404})
  end

  test "plain text requested" do
    response = build_response(404, request_headers: %{"accept" => "text/plain"})
    assert response.headers["content-type"] == "text/plain"
    assert response.body == "404, Belfrage"
  end

  test "error 404" do
    response = build_response(404)
    assert response.body == "<h1>404 Page Not Found</h1>\n<!-- Belfrage -->"

    assert response.cache_directive == %CacheControl{
             cacheability: "public",
             max_age: 30,
             stale_while_revalidate: 60,
             stale_if_error: 90
           }
  end

  test "error 405" do
    response = build_response(405)
    assert response.body == "<h1>405 Not Supported</h1>\n<!-- Belfrage -->"
  end

  test "error 500" do
    response = build_response(500)
    assert response.body == "<h1>500 Internal Server Error</h1>\n<!-- Belfrage -->"
  end

  test "error page template doesn't exist" do
    response = build_response(400)
    assert response.body == "<h1>400</h1>\n<!-- Belfrage -->"
  end

  for status <- Application.get_env(:belfrage, :redirect_statuses) do
    test "#{status} redirect" do
      response = build_response(unquote(status))
      assert response.body == ""

      assert response.cache_directive == %CacheControl{
               cacheability: "public",
               max_age: 60,
               stale_while_revalidate: 60,
               stale_if_error: 90
             }
    end
  end

  test "non-personalised request" do
    response = build_response(500, personalised: false)

    assert response.cache_directive == %CacheControl{
             cacheability: "public",
             max_age: 5,
             stale_while_revalidate: 15
           }
  end

  test "personalised request" do
    response = build_response(500, personalised: true)

    assert response.cache_directive == %CacheControl{
             cacheability: "private",
             max_age: 0,
             stale_while_revalidate: 15
           }
  end

  defp build_response(status, opts \\ []) do
    conn = Keyword.get(opts, :request_headers, %{}) |> build_conn()

    struct = %Struct{
      response: %Response{http_status: status},
      private: %Private{personalised_request: Keyword.get(opts, :personalised, false)}
    }

    Internal.new(struct, conn)
  end

  defp build_conn(headers) do
    Enum.reduce(headers, conn(:get, "/"), fn {header, value}, conn ->
      put_req_header(conn, header, value)
    end)
  end
end
