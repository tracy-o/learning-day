defmodule IngressWeb.ViewTest do
  use ExUnit.Case
  use Plug.Test

  alias IngressWeb.View
  alias Test.Support.StructHelper

  doctest View

  defp build_struct_and_render(body) do
    conn = conn(:get, "/_web_core")

    struct =
      StructHelper.build(
        response: %{
          body: body
        }
      )

    View.render(struct, conn)

    sent_resp(conn)
  end

  test "Rendering response from a struct with a 200 HTML response" do
    {status, _headers, body} = build_struct_and_render("<p>Basic HTML response</p>")

    assert status == 200
    assert body == "<p>Basic HTML response</p>"
  end

  test "Rendering response from a struct with a 200 Map response" do
    {status, _headers, body} = build_struct_and_render(%{some: "json data"})

    assert status == 200
    assert body == Poison.encode!(%{some: "json data"})
  end

  test "Rendering response from a struct with a 200 and a nil response" do
    {status, _headers, body} = build_struct_and_render(nil)

    assert status == 500
    assert body == "500 Internal Server Error"
  end
end
