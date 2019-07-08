defmodule BelfrageWeb.ViewTest do
  use ExUnit.Case
  use Plug.Test

  alias BelfrageWeb.View
  alias Test.Support.StructHelper

  doctest View

  defp build_struct_and_render(body) do
    StructHelper.build(response: %{body: body, http_status: 200})
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
    assert body == Jason.encode!(%{some: "json data"})
  end

  test "Rendering response from a struct with a 200 and a nil response" do
    {status, _headers, body} = build_struct_and_render(nil)

    assert status == 500
    assert body == "500 Internal Server Error"
  end

  test "Rendering a generic 500" do
    {status, _headers, body} =
      conn(:get, "/_web_core")
      |> View.internal_server_error()
      |> sent_resp()

    assert status == 500
    assert body == "500 Internal Server Error"
  end

  test "Rendering a generic 404" do
    {status, _headers, body} =
      conn(:get, "/_web_core")
      |> View.not_found()
      |> sent_resp()

    assert status == 404
    assert body == "404 Not Found"
  end
end
