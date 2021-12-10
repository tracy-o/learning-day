defmodule BelfrageWeb.RouteMasterTest do
  use ExUnit.Case, async: true
  use Plug.Test
  use Test.Support.Helper, :mox
  import Belfrage.Test.StubHelper, only: [stub_origins: 0]

  alias Routes.Routefiles.Mock, as: Routefile
  alias Routes.Routefiles.{RoutefileOnlyOnMock, RoutefileOnlyOnMultiEnvMock}

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

  describe "handle/2" do
    test "successful match" do
      stub_origins()

      conn =
        conn(:get, "/200-ok-response")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> Routefile.call([])

      assert conn.status == 200
    end
  end

  describe "calling handle with do block" do
    test "when 404 check is truthy 404 is returned" do
      conn =
        conn(:get, "/premature-404")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> Routefile.call([])

      assert conn.status == 404
      assert conn.resp_body =~ "404"
    end

    test "when 404 check is false, the request continues downstream" do
      stub_origins()

      conn =
        conn(:get, "/sends-request-downstream")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> Routefile.call([])

      assert conn.status == 200
    end
  end

  describe "calling handle with only_on option" do
    test "when the environments match, will yield request" do
      stub_origins()

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
      assert conn.resp_body =~ "404"
    end

    test "when the environments do not match, will match similar route from other environment" do
      stub_origins()

      conn =
        conn(:get, "/only-on-multi-env")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_other_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> fetch_query_params()
        |> RoutefileOnlyOnMultiEnvMock.call([])

      assert conn.status == 200
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
      assert conn.resp_body =~ "404"
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
      conn =
        conn(:get, "/permanent-redirect")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> Routefile.call([])

      assert conn.status == 301
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["/new-location"]
    end

    test "redirect is publicly cachable, with max-age set" do
      conn =
        conn(:get, "/permanent-redirect")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> Routefile.call([])

      assert get_resp_header(conn, "cache-control") == [
               "public, stale-if-error=90, stale-while-revalidate=60, max-age=60"
             ]
    end

    test "redirect retains the req-svc-chain header" do
      conn =
        conn(:get, "/permanent-redirect")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> Routefile.call([])

      assert get_resp_header(conn, "req-svc-chain") == ["GTM,BELFRAGE"]
    end

    test "redirect has a simple vary header" do
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
        |> Routefile.call([])

      assert get_resp_header(conn, "vary") == [
               "Accept-Encoding,X-BBC-Edge-Cache,X-Country,X-IP_Is_UK_Combined,X-BBC-Edge-Scheme"
             ]
    end

    test "with a simple path rewrite" do
      conn =
        conn(:get, "/rewrite-redirect/resource-id-123345")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> Routefile.call([])

      assert conn.status == 302
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["/new-location/resource-id-123345/somewhere"]
    end

    test "with a complex path rewrite" do
      conn =
        conn(:get, "/rewrite-redirect/12345/section/catch-all/i-am-a-url-slug-for-SEO")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> Routefile.call([])

      assert conn.status == 302
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["/new-location/section-12345/i-am-a-url-slug-for-SEO"]
    end

    test "with a simple path with extension rewrite" do
      conn =
        conn(:get, "/rewrite-redirect/resource-id-123345.ext")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> Routefile.call([])

      assert conn.status == 302
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["/new-location/resource-id-123345/anywhere"]
    end

    test "with a host redirect" do
      conn =
        conn(:get, "https://example.net/rewrite-redirect/12345/catch-all/i-am-a-url-slug-for-SEO")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> Routefile.call([])

      assert conn.status == 302
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["https://bbc.com/new-location/12345-i-am-a-url-slug-for-SEO"]
    end

    test "re-writes path variable into host" do
      conn =
        conn(:get, "https://example.net/rewrite-redirect/12345/i-am-a-url-slug-for-SEO")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> Routefile.call([])

      assert conn.status == 302
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["https://12345.bbc.com/new-location/i-am-a-url-slug-for-SEO"]
    end

    test "handle *any to *any redirects with format extension" do
      conn =
        conn(:get, "/redirect-with-path/feed.xml")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> Routefile.call([])

      assert conn.status == 302
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["/new-location-with-path/feed.xml"]
    end

    test "handle *any to *any redirects where any only includes the extension" do
      conn =
        conn(:get, "/some/path.js")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> Routefile.call([])

      assert conn.status == 301
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["/another-path.js"]
    end

    test "handle *any to *any redirects without format extension" do
      conn =
        conn(:get, "/redirect-with-path/subpath/asset-1234")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> Routefile.call([])

      assert conn.status == 302
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["/new-location-with-path/subpath/asset-1234"]
    end

    test "redirect can redirect to /" do
      conn =
        conn(:get, "/redirect-to-root")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> Routefile.call([])

      assert conn.status == 302
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["/"]
    end
  end

  describe "calling redirect with host" do
    test "redirect is publicly cachable, with max-age set" do
      conn =
        conn(:get, "http://www.bbcarabic.com")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> Routefile.call([])

      assert get_resp_header(conn, "cache-control") == [
               "public, stale-if-error=90, stale-while-revalidate=60, max-age=60"
             ]
    end

    test "when the redirect matches without a subdomain will return the location and status" do
      conn =
        conn(:get, "http://www.bbcarabic.com")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> Routefile.call([])

      assert conn.status == 302
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["https://www.bbc.com/arabic"]
    end

    test "when the redirect matches without a subdomain and a trailing slash will return the location and status" do
      conn =
        conn(:get, "https://bbcarabic.com/")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> Routefile.call([])

      assert conn.status == 302
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["https://www.bbc.com/arabic"]
    end

    test "when the redirect matches with a subdomain and without a trailing slash will return the location and status" do
      conn =
        conn(:get, "https://www.bbcarabic.com")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> Routefile.call([])

      assert conn.status == 302
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["https://www.bbc.com/arabic"]
    end

    test "when the redirect matches without a subdomain and without a trailing slash will return the location and status" do
      conn =
        conn(:get, "https://bbcarabic.com")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> Routefile.call([])

      assert conn.status == 302
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["https://www.bbc.com/arabic"]
    end

    test "when the redirect matches with a subdomain and trailing slash will return the location and status" do
      conn =
        conn(:get, "https://www.bbcarabic.com/")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> Routefile.call([])

      assert conn.status == 302
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["https://www.bbc.com/arabic"]
    end

    test "when the redirect matches with a path will return the location and status" do
      conn =
        conn(:get, "https://www.bbcarabic.com/middleeast-51412901")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> Routefile.call([])

      assert conn.status == 302
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["https://www.bbc.com/arabic/middleeast-51412901"]
    end

    test "when the redirect matches a multi-segment path it will return the location and status" do
      conn =
        conn(:get, "/redirect-with-path/abc")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> Routefile.call([])

      assert conn.status == 302
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["/new-location-with-path/abc"]
    end

    test "when the redirect matches with a path with extension will return the location and status" do
      conn =
        conn(:get, "/redirect-with-path.ext")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> Routefile.call([])

      assert conn.status == 302
      assert conn.resp_body == ""
      assert get_resp_header(conn, "location") == ["/new-location-with-path.ext"]
    end

    test "when the request is a POST it should not redirect" do
      conn =
        conn(:post, "/redirect-with-path/abc")
        |> put_bbc_headers()
        |> put_private(:production_environment, "some_environment")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> Routefile.call([])

      assert conn.status == 405
    end
  end

  describe "matching proxy_pass routes" do
    test "200 is returned when on the test env and origin_simulator header is set" do
      origin_simulator_header = "true"
      route = "/some-route-for-proxy-pass"

      stub_origins()

      conn =
        conn(:get, route)
        |> put_bbc_headers(origin_simulator_header)
        |> put_private(:production_environment, "test")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> Routefile.call([])

      assert conn.status == 200
      assert conn.assigns.route_spec == "ProxyPass"
    end

    test "200 is returned when on the test env and replayed_header header is set" do
      route = "/some-route-for-proxy-pass"

      stub_origins()

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
          cdn: true,
          req_svc_chain: "BELFRAGE",
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
        |> Routefile.call([])

      assert conn.status == 200
      assert conn.assigns.route_spec == "ProxyPass"
    end

    test "404 is returned when on test and origin_simulator header is not set" do
      route = "/some-route-for-proxy-pass"

      conn =
        conn(:get, route)
        |> put_bbc_headers()
        |> put_private(:production_environment, "test")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> Routefile.call([])

      assert conn.status == 404
    end

    test "404 is returned when origin_simulator is set but env is not test" do
      origin_simulator_header = "true"
      route = "/some-route-for-proxy-pass"

      conn =
        conn(:get, route)
        |> put_bbc_headers(origin_simulator_header)
        |> put_private(:production_environment, "live")
        |> put_private(:preview_mode, "off")
        |> put_private(:overrides, %{})
        |> Routefile.call([])

      assert conn.status == 404
    end

    test "404 is returned when replayed_header is set but env is not test" do
      route = "/some-route-for-proxy-pass"

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
        |> Routefile.call([])

      assert conn.status == 404
    end
  end

  describe "no_match/0" do
    # This could be extracted to another module using defroutefile
    defmodule RouteFileWithNoMatch do
      use BelfrageWeb.RouteMaster
      no_match()
    end

    # This could be extracted to another module using defroutefile
    defmodule RouteFileWithProxyPassAndNoMatch do
      @production_environment "test"
      use BelfrageWeb.RouteMaster
      handle_proxy_pass("/*any", using: "ProxyPass", only_on: "some_env", examples: ["/foo"])
      no_match()
    end

    test "defines a catch-all 404 GET route" do
      conn =
        conn(:get, "/a_route_that_will_not_match")
        |> put_bbc_headers()
        |> RouteFileWithNoMatch.call([])

      assert conn.status == 404
      assert conn.resp_body =~ "404"
    end

    test "defines a catch-all 405 route for all other HTTP methods" do
      conn =
        conn(:post, "/a_route_that_will_not_match")
        |> RouteFileWithNoMatch.call([])

      assert conn.status == 405
      assert conn.resp_body =~ "405"
    end

    test "defines a catch-all 404 GET route when there's a proxy-pass catch-all route for a different env" do
      conn =
        conn(:get, "/a_route_that_will_not_match")
        |> put_bbc_headers()
        |> RouteFileWithProxyPassAndNoMatch.call([])

      assert conn.status == 404
      assert conn.resp_body =~ "404"
    end
  end
end
