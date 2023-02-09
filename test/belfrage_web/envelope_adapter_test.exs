defmodule BelfrageWeb.EnvelopeAdapterTest do
  use ExUnit.Case
  use Plug.Test

  alias BelfrageWeb.EnvelopeAdapter

  defp put_test_production_environment(conn) do
    put_private(conn, :production_environment, "test")
  end

  defp put_preview_mode_off(conn) do
    put_private(conn, :preview_mode, "off")
  end

  defp put_request_id(conn) do
    put_private(conn, :request_id, "req-123456")
  end

  defp build_request(conn, override_headers \\ %{}) do
    bbc_headers =
      Map.merge(
        %{
          scheme: :https,
          host: nil,
          is_uk: false,
          is_advertise: false,
          country: "gb",
          query_string: nil,
          replayed_traffic: nil,
          origin_simulator: nil,
          varnish: 1,
          cache: 0,
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
        },
        override_headers
      )

    conn
    |> put_test_production_environment()
    |> put_request_id()
    |> put_preview_mode_off()
    |> put_private(:xray_trace_id, "1-xxxx-yyyyyyyyyyyyyyy")
    |> put_private(:bbc_headers, bbc_headers)
    |> put_private(:overrides, %{})
  end

  @route_state_id "SomeRouteState"

  test "Adds www as the subdomain to the envelope" do
    conn =
      conn(:get, "https://www.belfrage.com/sport/videos/12345678")
      |> build_request()

    assert "www" == EnvelopeAdapter.adapt(conn, @route_state_id).request.subdomain
  end

  test "When the subdomain is not www, it adds the subdomain of the host to the envelope" do
    conn =
      conn(:get, "https://test-branch.belfrage.com/_web_core")
      |> build_request(%{host: "test-branch.belfrage.com"})

    assert "test-branch" == EnvelopeAdapter.adapt(conn, @route_state_id).request.subdomain
  end

  test "when the host header is empty, we default to www" do
    conn =
      conn(:get, "https://www.belfrage.com/_web_core")
      |> build_request(%{host: ""})

    assert "www" == EnvelopeAdapter.adapt(conn, @route_state_id).request.subdomain
  end

  test "when the host header is not binary, we default to www" do
    conn =
      conn(:get, "https://www.belfrage.com/_web_core")
      |> build_request(%{host: nil})

    assert "www" == EnvelopeAdapter.adapt(conn, @route_state_id).request.subdomain
  end

  test "When the request contains a query string it is added to the envelope" do
    conn =
      conn(:get, "https://test-branch.belfrage.com/_web_core?page=6")
      |> build_request()
      |> fetch_query_params(_opts = [])

    assert %{"page" => "6"} == EnvelopeAdapter.adapt(conn, @route_state_id).request.query_params
  end

  test "When the request does not have a query string it adds an empty map to the envelope" do
    conn =
      conn(:get, "https://test-branch.belfrage.com/_web_core")
      |> build_request()
      |> fetch_query_params(_opts = [])

    assert %{} == EnvelopeAdapter.adapt(conn, @route_state_id).request.query_params
  end

  test "when the path has path parameters" do
    conn =
      conn(:get, "https://test-branch.belfrage.com/_web_core/article-1234")
      |> build_request()
      |> Map.put(:path_params, %{"id" => "article-1234"})

    assert %{"id" => "article-1234"} == EnvelopeAdapter.adapt(conn, @route_state_id).request.path_params
  end

  test "Adds the production_environment to the envelope" do
    conn =
      conn(:get, "https://www.belfrage.com/sport/videos/12345678")
      |> build_request()

    assert "test" == EnvelopeAdapter.adapt(conn, @route_state_id).private.production_environment
  end

  describe "accept_encoding value" do
    test "when an Accept-Encoding header is provided, the value is stored in envelope.request" do
      conn =
        conn(:get, "/")
        |> build_request()
        |> put_req_header("accept-encoding", "gzip, deflate, br")

      assert "gzip, deflate, br" == EnvelopeAdapter.adapt(conn, @route_state_id).request.accept_encoding
    end

    test "when an Accept-Encoding header is not provided" do
      conn =
        conn(:get, "/")
        |> build_request()

      assert nil == EnvelopeAdapter.adapt(conn, @route_state_id).request.accept_encoding
    end
  end

  test "when is_uk header is true, is_uk in the envelope is set to true" do
    conn =
      conn(:get, "/")
      |> build_request(%{is_uk: true})

    assert true == EnvelopeAdapter.adapt(conn, @route_state_id).request.is_uk
  end

  test "when the bbc_headers host is nil, uses host from the conn" do
    conn =
      conn(:get, "/")
      |> build_request(%{host: nil})

    assert EnvelopeAdapter.adapt(conn, @route_state_id).request.host == "www.example.com"
  end

  test "adds raw_headers to the envelope.request" do
    conn =
      conn(:get, "/")
      |> build_request()
      |> put_req_header("a-custom-header", "with this value")

    assert EnvelopeAdapter.adapt(conn, @route_state_id).request.raw_headers == %{
             "a-custom-header" => "with this value"
           }
  end

  test "adds request_id to the envelope.request" do
    conn =
      conn(:get, "/")
      |> build_request()
      |> put_req_header("a-custom-header", "with this value")

    assert EnvelopeAdapter.adapt(conn, @route_state_id).request.request_id == "req-123456"
  end

  describe "Adds app? to envelope.request" do
    test "with a value of true when the host matches" do
      Enum.each(["https://news-app.test.api.bbc.co.uk", "https://sport-app.test.api.bbc.co.uk"], fn url ->
        conn(:get, url)
        |> build_request()
        |> EnvelopeAdapter.adapt(@route_state_id)
        |> Map.get(:request)
        |> Map.get(:app?)
        |> assert()
      end)
    end

    test "with a value of false when the host does not match" do
      Enum.each(
        ["https://news.test.api.bbc.co.uk", "https://test.app.api.bbc.co.uk"],
        fn url ->
          conn(:get, url)
          |> build_request()
          |> EnvelopeAdapter.adapt(@route_state_id)
          |> Map.get(:request)
          |> Map.get(:app?)
          |> refute()
        end
      )
    end
  end
end
