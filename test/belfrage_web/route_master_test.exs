defmodule BelfrageWeb.RouteMasterTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox

  alias Belfrage.Struct
  alias Routes.{RoutefileMock, RoutefileOnlyOnMock, RoutefileOnlyOnMultiEnvMock}
  alias Belfrage.Helpers.FileIOMock

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

  defp put_bbc_headers(conn, origin_simulator \\ nil) do
    conn
    |> put_private(:xray_trace_id, "1-xxxx-yyyyyyyyyyyyyyy")
    |> put_private(:request_id, "req-12345678")
    |> put_private(:bbc_headers, %{
      country: "gb",
      scheme: "",
      host: "",
      is_uk: false,
      is_advertise: false,
      replayed_traffic: nil,
      origin_simulator: origin_simulator,
      varnish: "",
      cache: "",
      cdn: true,
      req_svc_chain: "GTM,BELFRAGE",
      x_cdn: nil,
      x_candy_audience: nil,
      x_candy_override: nil,
      x_candy_preview_guid: nil,
      x_morph_env: nil,
      x_use_fixture: nil,
      cookie_ckps_language: nil,
      cookie_ckps_chinese: nil,
      cookie_ckps_serbian: nil,
      origin: nil,
      referer: nil,
      user_agent: ""
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
    test "when the environments match, will yield request" do
      mock_handle_route("/only-on", "SomeLoop")

      conn =
        conn(:get, "/only-on")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> RoutefileOnlyOnMock.call([])

      assert conn.status == 200
    end

    test "when the environments do not match and no other matching route will return a 404" do
      conn =
        conn(:get, "/only-on")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_other_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> RoutefileOnlyOnMultiEnvMock.call([])

      assert conn.status == 404
      assert conn.resp_body == "content for file test/support/resources/not-found.html<!-- Belfrage -->"
    end

    test "when the environments do not match, will match similar route from other environment" do
      mock_handle_route("/only-on-multi-env", "SomeMozartLoop")

      conn =
        conn(:get, "/only-on-multi-env")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_other_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> RoutefileOnlyOnMultiEnvMock.call([])

      assert conn.status == 200
      assert conn.resp_body == "<p>Basic HTML response</p>"
    end
  end

  describe "calling handle with only_on option with a block" do
    test "when the environments match, will yield request and execute block" do
      conn =
        conn(:get, "/only-on-with-block")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> RoutefileOnlyOnMock.call([])

      assert conn.status == 200
      assert conn.resp_body == "block run"
    end

    test "when the environments do not match and no other matching route will return a 404" do
      conn =
        conn(:get, "/only-on-with-block")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_other_environment")
        |> put_private(:preview_mode, "off")
        |> RoutefileOnlyOnMultiEnvMock.call([])

      assert conn.status == 404
      assert conn.resp_body == "content for file test/support/resources/not-found.html<!-- Belfrage -->"
    end

    test "when the environments do not match, will match similar route from other environment ans execute block" do
      conn =
        conn(:get, "/only-on-with-block-multi-env")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_other_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> RoutefileOnlyOnMultiEnvMock.call([])

      assert conn.status == 200
      assert conn.resp_body == "block run from loop on another env"
    end
  end

  describe "calling redirect" do
    test "when the redirect matches will return the location and status" do
      expect_belfrage_not_called()

      conn =
        conn(:get, "/permanent-redirect")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> RoutefileMock.call([])

      assert conn.status == 301
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["/new-location"]
    end

    test "redirect is publicly cachable, with max-age set" do
      expect_belfrage_not_called()

      conn =
        conn(:get, "/permanent-redirect")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> RoutefileMock.call([])

      assert get_resp_header(conn, "cache-control") == [
               "public, stale-if-error=90, stale-while-revalidate=60, max-age=60"
             ]
    end

    test "redirect retains the req-svc-chain header" do
      expect_belfrage_not_called()

      conn =
        conn(:get, "/permanent-redirect")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> RoutefileMock.call([])

      assert get_resp_header(conn, "req-svc-chain") == ["GTM,BELFRAGE"]
    end

    test "redirect has a simple vary header" do
      expect_belfrage_not_called()

      conn =
        conn(:get, "/permanent-redirect")
        |> put_private(:xray_trace_id, "1-xxxx-yyyyyyyyyyyyyyy")
        |> put_private(:request_id, "req-12345678")
        |> put_private(:bbc_headers, %{
          country: "gb",
          scheme: "",
          host: "",
          is_uk: false,
          is_advertise: false,
          replayed_traffic: nil,
          origin_simulator: nil,
          varnish: "",
          cache: false,
          cdn: false,
          req_svc_chain: "GTM,BELFRAGE",
          x_cdn: nil,
          x_candy_audience: nil,
          x_candy_override: nil,
          x_candy_preview_guid: nil,
          x_morph_env: nil,
          x_use_fixture: nil,
          cookie_ckps_language: nil,
          cookie_ckps_chinese: nil,
          cookie_ckps_serbian: nil,
          origin: nil,
          referer: nil,
          user_agent: ""
        })
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> put_req_header("x-host", "www.bbc.co.uk")
        |> put_req_header("x-bbc-edge-host", "www.bbc.co.uk")
        |> put_req_header("cookie", "foo=bar")
        |> RoutefileMock.call([])

      assert get_resp_header(conn, "vary") == [
               "Accept-Encoding,X-BBC-Edge-Cache,X-Country,X-IP_Is_UK_Combined,X-BBC-Edge-Scheme"
             ]
    end

    test "with a simple path rewrite" do
      expect_belfrage_not_called()

      conn =
        conn(:get, "/rewrite-redirect/resource-id-123345")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> RoutefileMock.call([])

      assert conn.status == 302
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["/new-location/resource-id-123345/somewhere"]
    end

    test "with a complex path rewrite" do
      expect_belfrage_not_called()

      conn =
        conn(:get, "/rewrite-redirect/12345/section/catch-all/i-am-a-url-slug-for-SEO")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> RoutefileMock.call([])

      assert conn.status == 302
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["/new-location/section-12345/i-am-a-url-slug-for-SEO"]
    end

    test "with a simple path with extension rewrite" do
      expect_belfrage_not_called()

      conn =
        conn(:get, "/rewrite-redirect/resource-id-123345.ext")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> RoutefileMock.call([])

      assert conn.status == 302
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["/new-location/resource-id-123345/anywhere"]
    end

    test "with a host redirect" do
      expect_belfrage_not_called()

      conn =
        conn(:get, "https://example.net/rewrite-redirect/12345/catch-all/i-am-a-url-slug-for-SEO")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> RoutefileMock.call([])

      assert conn.status == 302
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["https://bbc.com/new-location/12345-i-am-a-url-slug-for-SEO"]
    end

    test "re-writes path variable into host" do
      expect_belfrage_not_called()

      conn =
        conn(:get, "https://example.net/rewrite-redirect/12345/i-am-a-url-slug-for-SEO")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> RoutefileMock.call([])

      assert conn.status == 302
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["https://12345.bbc.com/new-location/i-am-a-url-slug-for-SEO"]
    end

    test "handle *any to *any redirects with format extension" do
      expect_belfrage_not_called()

      conn =
        conn(:get, "/redirect-with-path/feed.xml")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> RoutefileMock.call([])

      assert conn.status == 302
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["/new-location-with-path/feed.xml"]
    end

    test "handle *any to *any redirects where any only includes the extension" do
      expect_belfrage_not_called()

      conn =
        conn(:get, "/some/path.js")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> RoutefileMock.call([])

      assert conn.status == 301
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["/another-path.js"]
    end

    test "handle *any to *any redirects without format extension" do
      expect_belfrage_not_called()

      conn =
        conn(:get, "/redirect-with-path/subpath/asset-1234")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> RoutefileMock.call([])

      assert conn.status == 302
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["/new-location-with-path/subpath/asset-1234"]
    end
  end

  describe "calling redirect with host" do
    test "redirect is publicly cachable, with max-age set" do
      expect_belfrage_not_called()

      conn =
        conn(:get, "http://www.bbcarabic.com")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> RoutefileMock.call([])

      assert get_resp_header(conn, "cache-control") == [
               "public, stale-if-error=90, stale-while-revalidate=60, max-age=60"
             ]
    end

    test "when the redirect matches without a subdomain will return the location and status" do
      expect_belfrage_not_called()

      conn =
        conn(:get, "http://www.bbcarabic.com")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> RoutefileMock.call([])

      assert conn.status == 302
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["https://www.bbc.com/arabic"]
    end

    test "when the redirect matches without a subdomain and a trailing slash will return the location and status" do
      expect_belfrage_not_called()

      conn =
        conn(:get, "https://bbcarabic.com/")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> RoutefileMock.call([])

      assert conn.status == 302
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["https://www.bbc.com/arabic"]
    end

    test "when the redirect matches with a subdomain and without a trailing slash will return the location and status" do
      expect_belfrage_not_called()

      conn =
        conn(:get, "https://www.bbcarabic.com")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> RoutefileMock.call([])

      assert conn.status == 302
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["https://www.bbc.com/arabic"]
    end

    test "when the redirect matches without a subdomain and without a trailing slash will return the location and status" do
      expect_belfrage_not_called()

      conn =
        conn(:get, "https://bbcarabic.com")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> RoutefileMock.call([])

      assert conn.status == 302
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["https://www.bbc.com/arabic"]
    end

    test "when the redirect matches with a subdomain and trailing slash will return the location and status" do
      expect_belfrage_not_called()

      conn =
        conn(:get, "https://www.bbcarabic.com/")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> RoutefileMock.call([])

      assert conn.status == 302
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["https://www.bbc.com/arabic"]
    end

    test "when the redirect matches with a path will return the location and status" do
      expect_belfrage_not_called()

      conn =
        conn(:get, "https://www.bbcarabic.com/middleeast-51412901")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> RoutefileMock.call([])

      assert conn.status == 302
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["https://www.bbc.com/arabic/middleeast-51412901"]
    end

    test "when the redirect matches a multi-segment path it will return the location and status" do
      expect_belfrage_not_called()

      conn =
        conn(:get, "/redirect-with-path/abc")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> RoutefileMock.call([])

      assert conn.status == 302
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["/new-location-with-path/abc"]
    end

    test "when the redirect matches with a path with extension will return the location and status" do
      expect_belfrage_not_called()

      conn =
        conn(:get, "/redirect-with-path.ext")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> RoutefileMock.call([])

      assert conn.status == 302
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["/new-location-with-path.ext"]
    end

    test "when the request is a POST it should not redirect" do
      expect_belfrage_not_called()

      conn =
        conn(:post, "/redirect-with-path/abc")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> RoutefileMock.call([])

      assert conn.status == 405
    end
  end

  describe "matching proxy_pass routes" do
    test "200 is returned when on the test env and origin_simulator header is set" do
      origin_simulator_header = "true"
      route = "/some-route-for-proxy-pass"

      BelfrageMock
      |> expect(:handle, fn %Struct{
                              private: %Struct.Private{loop_id: "ProxyPass", production_environment: "test"},
                              request: %Struct.Request{path: _route, origin_simulator?: _origin_simulator_header}
                            } ->
        @struct_with_html_response
      end)

      conn =
        conn(:get, route)
        |> put_bbc_headers(origin_simulator_header)
        |> put_private(:production_environment, "test")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> RoutefileMock.call([])

      assert conn.status == 200
    end

    test "200 is returned when on the test env and replayed_header header is set" do
      route = "/some-route-for-proxy-pass"

      BelfrageMock
      |> expect(:handle, fn %Struct{
                              private: %Struct.Private{loop_id: "ProxyPass", production_environment: "test"},
                              request: %Struct.Request{path: _route, has_been_replayed?: _replayed_traffic_header}
                            } ->
        @struct_with_html_response
      end)

      conn =
        conn(:get, route)
        |> put_private(:xray_trace_id, "1-xxxx-yyyyyyyyyyyyyyy")
        |> put_private(:request_id, "req-12345678")
        |> put_private(:bbc_headers, %{
          country: "gb",
          scheme: "",
          host: "",
          is_uk: false,
          is_advertise: false,
          replayed_traffic: "true",
          origin_simulator: nil,
          varnish: "",
          cache: "",
          cdn: false,
          req_svc_chain: "BELFRAGE",
          x_cdn: nil,
          x_candy_audience: nil,
          x_candy_override: nil,
          x_candy_preview_guid: nil,
          x_morph_env: nil,
          x_use_fixture: nil,
          cookie_ckps_language: nil,
          cookie_ckps_chinese: nil,
          cookie_ckps_serbian: nil,
          origin: nil,
          referer: nil,
          user_agent: ""
        })
        |> put_private(:production_environment, "test")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> RoutefileMock.call([])

      assert conn.status == 200
    end

    test "404 is returned when on test and origin_simulator header is not set" do
      route = "/some-route-for-proxy-pass"

      expect_belfrage_not_called()

      conn =
        conn(:get, route)
        |> put_bbc_headers()
        |> put_private(:production_environment, "test")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> RoutefileMock.call([])

      assert conn.status == 404
    end

    test "404 is returned when origin_simulator is set but env is not test" do
      origin_simulator_header = "true"
      route = "/some-route-for-proxy-pass"

      expect_belfrage_not_called()

      conn =
        conn(:get, route)
        |> put_bbc_headers(origin_simulator_header)
        |> put_private(:production_environment, "live")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> RoutefileMock.call([])

      assert conn.status == 404
    end

    test "404 is returned when replayed_header is set but env is not test" do
      route = "/some-route-for-proxy-pass"

      expect_belfrage_not_called()

      conn =
        conn(:get, route)
        |> put_private(:bbc_headers, %{
          country: "gb",
          scheme: "",
          host: "",
          is_uk: false,
          is_advertise: false,
          replayed_traffic: "true",
          origin_simulator: nil,
          varnish: "",
          cache: "",
          cdn: false,
          req_svc_chain: "BELFRAGE",
          x_cdn: nil,
          x_candy_audience: nil,
          x_candy_override: nil,
          x_candy_preview_guid: nil,
          x_morph_env: nil,
          x_use_fixture: nil,
          cookie_ckps_language: nil,
          cookie_ckps_chinese: nil,
          cookie_ckps_serbian: nil,
          origin: nil,
          referer: nil,
          user_agent: ""
        })
        |> put_private(:production_environment, "live")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> RoutefileMock.call([])

      assert conn.status == 404
    end
  end

  describe "no_match/0" do
    defmodule RouteFileWithNoMatch do
      use BelfrageWeb.RouteMaster
      no_match()
    end

    test "defines a catch-all 404 GET route" do
      expect_belfrage_not_called()
      not_found_page = Application.get_env(:belfrage, :not_found_page)

      expect(FileIOMock, :read, fn ^not_found_page -> {:ok, "<h1>404 Error Page</h1>\n"} end)

      conn =
        conn(:get, "/a_route_that_will_not_match")
        |> put_bbc_headers()
        |> RouteFileWithNoMatch.call([])

      assert conn.status == 404
      assert conn.resp_body == "<h1>404 Error Page</h1>\n<!-- Belfrage -->"
    end

    test "defines a catch-all 405 route for all other HTTP methods" do
      expect_belfrage_not_called()
      not_supported_page = Application.get_env(:belfrage, :not_supported_page)

      expect(FileIOMock, :read, fn ^not_supported_page -> {:ok, "<h1>405 Error Page</h1>\n"} end)

      conn =
        conn(:post, "/a_route_that_will_not_match")
        |> RouteFileWithNoMatch.call([])

      assert conn.status == 405
      assert conn.resp_body == "<h1>405 Error Page</h1>\n<!-- Belfrage -->"
    end
  end
end
