defmodule BelfrageWeb.ViewTest do
  use ExUnit.Case
  use Plug.Test

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

  test "Rendering response from a struct with a 200 and a nil response" do
    {status, _headers, body} = build_struct_and_render(nil)

    assert status == 500
    assert body == "<h1>500 Error Page</h1>\n<!-- Belfrage -->"
  end

  test "Rendering a generic 500" do
    {status, _headers, body} =
      conn(:get, "/_web_core")
      |> View.internal_server_error()
      |> sent_resp()

    assert status == 500
    assert body == "<h1>500 Error Page</h1>\n<!-- Belfrage -->"
  end

  test "Rendering a generic 404" do
    {status, _headers, body} =
      conn(:get, "/_web_core")
      |> View.not_found()
      |> sent_resp()

    assert status == 404
    assert body == "<h1>404 Error Page</h1>\n<!-- Belfrage -->"
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
      assert {"bfa", "1"} in headers
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
      refute {"bfa", "1"} in headers
    end
  end
end
