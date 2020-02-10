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
    conn
    |> put_private(:xray_trace_id, "1-xxxx-yyyyyyyyyyyyyyy")
    |> put_private(:bbc_headers, %{
      country: "gb",
      scheme: "",
      host: "",
      replayed_traffic: "",
      varnish: "",
      cache: ""
    })
  end

  describe "calling handle with do block" do
    test "when 404 check is truthy, route is not called" do
      expect_belfrage_not_called()

      conn =
        conn(:get, "/premature-404")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> RoutefileMock.call([])

      assert conn.status == 404
      assert conn.resp_body == "404 Not Found"
    end

    test "when 404 check is false, the request continues downstream" do
      mock_handle_route("/sends-request-downstream", "SomeLoop")

      conn =
        conn(:get, "/sends-request-downstream")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:overrides, %{})
        |> RoutefileMock.call([])

      assert conn.status == 200
    end
  end

  describe "calling handle with only_on option" do
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
        |> put_private(:overrides, %{})
        |> RoutefileMock.call([])

      assert conn.status == 200
    end
  end

  describe "calling redirect" do
    test "when the redirect matches will return the location and status" do
      expect_belfrage_not_called()

      conn =
        conn(:redirect, "/permanent-redirect")
        |> RoutefileMock.call([])

      assert conn.status == 301
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["/new-location"]
    end
  end
end
