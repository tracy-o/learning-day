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
      is_uk: false,
      replayed_traffic: "",
      varnish: "",
      cache: ""
    })
  end

  describe "calling handle with do block" do
    test "when 404 check is truthy, route is not called" do
      expect_belfrage_not_called()
      not_found_page = Application.get_env(:belfrage, :not_found_page)

      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn ^not_found_page -> {:ok, "<h1>404 Error Page</h1>\n"} end)

      conn =
        conn(:get, "/premature-404")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> RoutefileMock.call([])

      assert conn.status == 404
      assert conn.resp_body == "<h1>404 Error Page</h1>\n<!-- Belfrage -->"
    end

    test "when 404 check is false, the request continues downstream" do
      mock_handle_route("/sends-request-downstream", "SomeLoop")

      conn =
        conn(:get, "/sends-request-downstream")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> RoutefileMock.call([])

      assert conn.status == 200
    end
  end

  describe "calling handle with only_on option" do
    test "when the environments dont match, it will return a 404" do
      expect_belfrage_not_called()
      not_found_page = Application.get_env(:belfrage, :not_found_page)

      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn ^not_found_page -> {:ok, "<h1>404 Error Page</h1>\n"} end)

      conn =
        conn(:get, "/only-on")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_other_environment")
        |> put_private(:preview_mode, "off")
        |> RoutefileMock.call([])

      assert conn.status == 404
      assert conn.resp_body == "<h1>404 Error Page</h1>\n<!-- Belfrage -->"
    end

    test "when the environments match, it will continue with the request" do
      mock_handle_route("/only-on", "SomeLoop")

      conn =
        conn(:get, "/only-on")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> RoutefileMock.call([])

      assert conn.status == 200
    end
  end

  describe "calling redirect" do
    test "when the redirect matches will return the location and status" do
      expect_belfrage_not_called()

      conn =
        conn(:get, "/permanent-redirect")
        |> RoutefileMock.call([])

      assert conn.status == 301
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["/new-location"]
    end
  end

  describe "calling redirect with host" do
    test "when the redirect matches without a subdomain will return the location and status" do
      expect_belfrage_not_called()

      conn =
        conn(:get, "http://www.bbcarabic.com")
        |> RoutefileMock.call([])

      assert conn.status == 302
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["https://www.bbc.com/arabic"]
    end

    test "when the redirect matches without a subdomain and a trailing slash will return the location and status" do
      expect_belfrage_not_called()

      conn =
        conn(:get, "https://bbcarabic.com/")
        |> RoutefileMock.call([])

      assert conn.status == 302
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["https://www.bbc.com/arabic"]
    end

    test "when the redirect matches with a subdomain and without a trailing slash will return the location and status" do
      expect_belfrage_not_called()

      conn =
        conn(:get, "https://www.bbcarabic.com")
        |> RoutefileMock.call([])

      assert conn.status == 302
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["https://www.bbc.com/arabic"]
    end

    test "when the redirect matches without a subdomain and without a trailing slash will return the location and status" do
      expect_belfrage_not_called()

      conn =
        conn(:get, "https://bbcarabic.com")
        |> RoutefileMock.call([])

      assert conn.status == 302
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["https://www.bbc.com/arabic"]
    end

    test "when the redirect matches with a subdomain and trailing slash will return the location and status" do
      expect_belfrage_not_called()

      conn =
        conn(:get, "https://www.bbcarabic.com/")
        |> RoutefileMock.call([])

      assert conn.status == 302
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["https://www.bbc.com/arabic"]
    end

    test "when the redirect matches with a path will return the location and status" do
      expect_belfrage_not_called()

      conn =
        conn(:get, "https://www.bbcarabic.com/middleeast-51412901")
        |> RoutefileMock.call([])

      assert conn.status == 302
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["https://www.bbc.com/arabic/middleeast-51412901"]
    end
  end

  describe "matching undefined routes" do
    test "404 is returned for non-matching GET requests" do
      expect_belfrage_not_called()
      not_found_page = Application.get_env(:belfrage, :not_found_page)

      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn ^not_found_page -> {:ok, "<h1>404 Error Page</h1>\n"} end)

      conn =
        conn(:get, "/a_route_that_will_not_match")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> RoutefileMock.call([])

      assert conn.status == 404
      assert conn.resp_body == "<h1>404 Error Page</h1>\n<!-- Belfrage -->"
    end

    test "405 is returned with 405 page for unsupported methods" do
      expect_belfrage_not_called()
      not_supported_page = Application.get_env(:belfrage, :not_supported_page)

      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn ^not_supported_page -> {:ok, "<h1>405 Error Page</h1>\n"} end)

      conn =
        conn(:post, "/a_route_that_will_not_match")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> RoutefileMock.call([])

      assert conn.status == 405
      assert conn.resp_body == "<h1>405 Error Page</h1>\n<!-- Belfrage -->"
    end
  end
end
