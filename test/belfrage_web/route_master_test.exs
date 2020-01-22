defmodule BelfrageWeb.RouteMasterTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox

  alias Belfrage.Struct
  alias Routes.RoutefileMock

  @struct_with_html_response %Struct{
    response: %Struct.Response{
      body: "<p>Basic HTML response</p>",
      headers: %{"content-type" => "text/html; charset=utf-8"},
      http_status: 200
    }
  }

  defp expect_belfrage_not_called() do
    BelfrageMock
    |> expect(:handle, 0, fn _struct ->
      raise "this should never run"
    end)
  end

  defp mock_handle_route(path, loop_id) do
    BelfrageMock
    |> expect(:handle, fn %Struct{
                            private: %Struct.Private{loop_id: ^loop_id},
                            request: %Struct.Request{path: ^path}
                          } ->
      @struct_with_html_response
    end)
  end

  defp put_bbc_headers(conn) do
    put_private(conn, :bbc_headers, %{
      country: "gb",
      scheme: "",
      host: "",
      replayed_traffic: "",
      varnish: "",
      cache: ""
    })
  end

  describe "calling handle that uses a do block" do
    test "only executes the do block" do
      expect_belfrage_not_called()

      conn =
        conn(:get, "/not-found")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> RoutefileMock.call([])

      assert conn.status == 404
      assert conn.resp_body == "404 Not Found"
    end

    test "yeilds to the route" do
      mock_handle_route("/never-not-found", "SomeLoop")

      conn =
        conn(:get, "/never-not-found")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> RoutefileMock.call([])

      assert conn.status == 200
    end
  end

  describe "calling handle when using the only_on option" do
    test "when the environments dont match, it will return a 404" do
      expect_belfrage_not_called()

      conn =
        conn(:get, "/only-on")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_other_environment")
        |> RoutefileMock.call([])

      assert conn.status == 404
      assert conn.resp_body == "404 Not Found"
    end

    test "when the environments match, it will continue with the request" do
      mock_handle_route("/only-on", "SomeLoop")

      conn =
        conn(:get, "/only-on")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> RoutefileMock.call([])

      assert conn.status == 200
    end
  end
end
