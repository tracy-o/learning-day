defmodule Belfrage.EnvelopeTest do
  use ExUnit.Case
  use Plug.Test

  alias Belfrage.Envelope

  describe "loggable/1" do
    test "removes response body" do
      assert "REMOVED" == Envelope.loggable(%Envelope{}).response.body
    end

    test "removes request header PII" do
      envelope = %Envelope{request: %Envelope.Request{raw_headers: %{"cookie" => "abc123"}}}
      assert %Envelope{request: %Envelope.Request{raw_headers: [{"cookie", "REDACTED"}]}} = Envelope.loggable(envelope)
    end

    test "removes response header PII" do
      envelope = %Envelope{response: %Envelope.Response{headers: %{"set-cookie" => "abc123"}}}

      assert %Envelope{response: %Envelope.Response{headers: [{"set-cookie", "REDACTED"}]}} =
               Envelope.loggable(envelope)
    end

    test "removes session_token PII" do
      envelope = %Envelope{user_session: %Envelope.UserSession{:session_token => "some-token"}}
      assert %Envelope{user_session: %Envelope.UserSession{:session_token => "REDACTED"}} = Envelope.loggable(envelope)
    end

    test "keeps nil session_token values" do
      envelope = %Envelope{user_session: %Envelope.UserSession{:session_token => nil}}
      assert %Envelope{user_session: %Envelope.UserSession{:session_token => nil}} = Envelope.loggable(envelope)
    end

    test "keeps non-PII request headers" do
      envelope = %Envelope{request: %Envelope.Request{raw_headers: %{"foo" => "bar"}}}
      assert %Envelope{request: %Envelope.Request{raw_headers: [{"foo", "bar"}]}} = Envelope.loggable(envelope)
    end

    test "keeps non-PII response headers" do
      envelope = %Envelope{response: %Envelope.Response{headers: %{"foo" => "bar"}}}
      assert %Envelope{response: %Envelope.Response{headers: [{"foo", "bar"}]}} = Envelope.loggable(envelope)
    end

    test "removes cookies section from envelope.request" do
      envelope = %Envelope{request: %Envelope.Request{cookies: %{"foo" => "bar"}}}

      assert %Envelope{request: %Envelope.Request{cookies: "REMOVED"}} = Envelope.loggable(envelope)
    end

    test "removes user_attributes" do
      envelope = %Envelope{
        user_session: %Envelope.UserSession{
          user_attributes: %{
            "pseudonym" => "LzQfAmR2kar",
            "allow_personalisation" => true,
            "age_bracket" => "o18"
          }
        }
      }

      assert %Envelope{user_session: %Envelope.UserSession{:user_attributes => "REMOVED"}} = Envelope.loggable(envelope)
    end
  end

  describe "when amending the private section of an envelope" do
    @spec_name "SomeRouteSpec"

    test "adds the production_environment and spec to the envelope" do
      conn =
        conn(:get, "https://www.belfrage.com/sport/videos/12345678")
        |> build_request()

      envelope = Envelope.adapt_private(%Envelope{}, conn.private, @spec_name)

      assert "test" == envelope.private.production_environment
      assert @spec_name == envelope.private.spec
    end
  end

  describe "when amending the request section of the envelope" do
    @envelope %Envelope{}

    test "adds www as the subdomain to the envelope" do
      conn =
        conn(:get, "https://www.belfrage.com/sport/videos/12345678")
        |> build_request()

      assert "www" == Envelope.adapt_request(@envelope, conn).request.subdomain
    end

    test "adds the host's subdomain to the envelope when the subdomain is not www" do
      conn =
        conn(:get, "https://test-branch.belfrage.com/_web_core")
        |> build_request(%{host: "test-branch.belfrage.com"})

      assert "test-branch" == Envelope.adapt_request(@envelope, conn).request.subdomain
    end

    test "defaults to www when the host header is empty" do
      conn =
        conn(:get, "https://www.belfrage.com/_web_core")
        |> build_request(%{host: ""})

      assert "www" == Envelope.adapt_request(@envelope, conn).request.subdomain
    end

    test "defaults to www when the host header is nil" do
      conn =
        conn(:get, "https://www.belfrage.com/_web_core")
        |> build_request(%{host: nil})

      assert "www" == Envelope.adapt_request(@envelope, conn).request.subdomain
    end

    test "adds query strings to the envelope" do
      conn =
        conn(:get, "https://test-branch.belfrage.com/_web_core?page=6")
        |> build_request()
        |> fetch_query_params(_opts = [])

      assert %{"page" => "6"} == Envelope.adapt_request(@envelope, conn).request.query_params
    end

    test "adds an empty to the envelope when the request does not have a query string" do
      conn =
        conn(:get, "https://test-branch.belfrage.com/_web_core")
        |> build_request()
        |> fetch_query_params(_opts = [])

      assert %{} == Envelope.adapt_request(@envelope, conn).request.query_params
    end

    test "adds path params to the envelope" do
      conn =
        conn(:get, "https://test-branch.belfrage.com/_web_core/article-1234")
        |> build_request()
        |> Map.put(:path_params, %{"id" => "article-1234"})

      assert %{"id" => "article-1234"} == Envelope.adapt_request(@envelope, conn).request.path_params
    end

    test "stores the Accept-Encoding header value, when present" do
      conn =
        conn(:get, "/")
        |> build_request()
        |> put_req_header("accept-encoding", "gzip, deflate, br")

      assert "gzip, deflate, br" == Envelope.adapt_request(@envelope, conn).request.accept_encoding
    end

    test "doesn't store a default value if an Accept-Encoding header is not provided" do
      conn =
        conn(:get, "/")
        |> build_request()

      assert nil == Envelope.adapt_request(@envelope, conn).request.accept_encoding
    end

    test "sets 'is_uk' to true when is_uk header is true" do
      conn =
        conn(:get, "/")
        |> build_request(%{is_uk: true})

      assert true == Envelope.adapt_request(@envelope, conn).request.is_uk
    end

    test "when the bbc_headers host is nil, uses host from the conn" do
      conn =
        conn(:get, "/")
        |> build_request(%{host: nil})

      assert Envelope.adapt_request(@envelope, conn).request.host == "www.example.com"
    end

    test "adds request_id to the envelope.request" do
      conn =
        conn(:get, "/")
        |> build_request()
        |> put_req_header("a-custom-header", "with this value")

      assert Envelope.adapt_request(@envelope, conn).request.request_id == "req-123456"
    end

    test "sets 'app?' to true if subdomain contains 'app'" do
      conn =
        conn(:get, "https://news-app.test.api.bbc.co.uk")
        |> build_request()

      assert Envelope.adapt_request(@envelope, conn).request.app?
    end

    test "sets 'app?' to false if the subdomain does not contains 'app'" do
      conn =
        conn(:get, "https://news.test.test.api.bbc.co.uk")
        |> build_request()

      refute Envelope.adapt_request(@envelope, conn).request.app?
    end
  end

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
end
