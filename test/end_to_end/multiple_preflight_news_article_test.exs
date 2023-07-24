defmodule EndToEnd.MultiplePreflightNewsArticleTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  import Belfrage.Test.CachingHelper, only: [clear_preflight_metadata_cache: 1]
  import Test.Support.Helper, only: [set_stack_id: 1]
  alias BelfrageWeb.Router
  alias Belfrage.Clients.{HTTP, HTTPMock, LambdaMock}

  @fabl_endpoint Application.compile_env!(:belfrage, :fabl_endpoint)
  @mozart_news_endpoint Application.compile_env!(:belfrage, :mozart_news_endpoint)
  @path "/news/uk-87654321"

  setup :clear_preflight_metadata_cache

  describe "News article route behaviour on Joan" do
    setup do
      set_stack_id("joan")
      :ok
    end

    test "when asset type is a Web Core asset and Ares dial on" do
      fabl_url = "#{@fabl_endpoint}/module/ares-asset-identifier?path=%2Fnews%2Fuk-87654321"

      HTTPMock
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: ^fabl_url
           },
           :Preflight ->
          {:ok,
           %HTTP.Response{
             status_code: 200,
             body: "{\"data\": {\"type\": \"STY\"}}"
           }}
        end
      )

      expect(LambdaMock, :call, fn _credentials, _arn, _request, _ ->
        {:ok,
         %{
           "headers" => %{},
           "statusCode" => 200,
           "body" => "<h1>Hello from the Lambda!</h1>"
         }}
      end)

      conn =
        conn(:get, "/news/uk-87654321")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert {200, _headers, "<h1>Hello from the Lambda!</h1>"} = sent_resp(conn)
    end

    test "when asset type is a Mozart asset and Ares dial on" do
      fabl_url = "#{@fabl_endpoint}/module/ares-asset-identifier?path=%2Fnews%2Fuk-87654321"

      HTTPMock
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: ^fabl_url
           },
           :Preflight ->
          {:ok,
           %HTTP.Response{
             status_code: 200,
             body: "{\"data\": {\"type\": \"FIX\"}}"
           }}
        end
      )

      mozart_url = "#{@mozart_news_endpoint}#{@path}"

      HTTPMock
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: ^mozart_url
           },
           :MozartNews ->
          {:ok,
           %HTTP.Response{
             status_code: 200,
             body: "<h1>Hello from MozartNews!</h1>"
           }}
        end
      )

      conn =
        conn(:get, "/news/uk-87654321")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert {200, _headers, "<h1>Hello from MozartNews!</h1>"} = sent_resp(conn)
    end

    # At some point this will raise for a fallback when there is a data error
    test "when asset type is unknown due to a data error and Ares dial on" do
      fabl_url = "#{@fabl_endpoint}/module/ares-asset-identifier?path=%2Fnews%2Fuk-87654321"

      HTTPMock
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: ^fabl_url
           },
           :Preflight ->
          {:ok,
           %HTTP.Response{
             status_code: 500
           }}
        end
      )

      mozart_url = "#{@mozart_news_endpoint}#{@path}"

      HTTPMock
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: ^mozart_url
           },
           :MozartNews ->
          {:ok,
           %HTTP.Response{
             status_code: 200,
             body: "<h1>Hello from MozartNews!</h1>"
           }}
        end
      )

      conn =
        conn(:get, "/news/uk-87654321")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert {200, _headers, "<h1>Hello from MozartNews!</h1>"} = sent_resp(conn)
    end

    test "when asset type is a Web Core asset and Ares dial set to logging mode" do
      stub_dial(:preflight_ares_data_fetch, "learning")

      fabl_url = "#{@fabl_endpoint}/module/ares-asset-identifier?path=%2Fnews%2Fuk-87654321"

      HTTPMock
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: ^fabl_url
           },
           :Preflight ->
          {:ok,
           %HTTP.Response{
             status_code: 200,
             body: "{\"data\": {\"type\": \"STY\"}}"
           }}
        end
      )

      mozart_url = "#{@mozart_news_endpoint}#{@path}"

      HTTPMock
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: ^mozart_url
           },
           :MozartNews ->
          {:ok,
           %HTTP.Response{
             status_code: 200,
             body: "<h1>Hello from MozartNews!</h1>"
           }}
        end
      )

      conn =
        conn(:get, "/news/uk-87654321")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert {200, _headers, "<h1>Hello from MozartNews!</h1>"} = sent_resp(conn)
    end

    test "when asset type is a Mozart asset and Ares dial set to logging mode" do
      stub_dial(:preflight_ares_data_fetch, "learning")

      fabl_url = "#{@fabl_endpoint}/module/ares-asset-identifier?path=%2Fnews%2Fuk-87654321"

      HTTPMock
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: ^fabl_url
           },
           :Preflight ->
          {:ok,
           %HTTP.Response{
             status_code: 200,
             body: "{\"data\": {\"type\": \"FIX\"}}"
           }}
        end
      )

      mozart_url = "#{@mozart_news_endpoint}#{@path}"

      HTTPMock
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: ^mozart_url
           },
           :MozartNews ->
          {:ok,
           %HTTP.Response{
             status_code: 200,
             body: "<h1>Hello from MozartNews!</h1>"
           }}
        end
      )

      conn =
        conn(:get, "/news/uk-87654321")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert {200, _headers, "<h1>Hello from MozartNews!</h1>"} = sent_resp(conn)
    end

    # At some point this will raise for a fallback when unable to fetch data
    test "when Ares dial disabled" do
      stub_dial(:preflight_ares_data_fetch, "off")

      mozart_url = "#{@mozart_news_endpoint}#{@path}"

      HTTPMock
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: ^mozart_url
           },
           :MozartNews ->
          {:ok,
           %HTTP.Response{
             status_code: 200,
             body: "<h1>Hello from MozartNews!</h1>"
           }}
        end
      )

      conn =
        conn(:get, "/news/uk-87654321")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert {200, _headers, "<h1>Hello from MozartNews!</h1>"} = sent_resp(conn)
    end

    test "when asset type is a Web Core asset and Ares dial on and request is BBCX" do
      stub_dials(bbcx_enabled: "true")

      fabl_url = "#{@fabl_endpoint}/module/ares-asset-identifier?path=%2Fnews%2Fuk-87654321"

      HTTPMock
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: ^fabl_url
           },
           :Preflight ->
          {:ok,
           %HTTP.Response{
             status_code: 200,
             body: "{\"data\": {\"type\": \"STY\"}}"
           }}
        end
      )
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: "https://web.test.bbcx-internal.com/news/uk-87654321"
           },
           :BBCX ->
          {:ok,
           %HTTP.Response{
             status_code: 200,
             body: "<h1>Hello from BBCX!</h1>"
           }}
        end
      )

      conn =
        conn(:get, "/news/uk-87654321")
        |> put_req_header("cookie-ckns_bbccom_beta", "1")
        |> put_req_header("x-bbc-edge-host", "www.bbc.com")
        |> put_req_header("x-country", "us")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert {200, _headers, "<h1>Hello from BBCX!</h1>"} = sent_resp(conn)
    end

    test "when asset type is a Mozart asset and Ares dial on and request is BBCX" do
      stub_dials(bbcx_enabled: "true")

      fabl_url = "#{@fabl_endpoint}/module/ares-asset-identifier?path=%2Fnews%2Fuk-87654321"

      HTTPMock
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: ^fabl_url
           },
           :Preflight ->
          {:ok,
           %HTTP.Response{
             status_code: 200,
             body: "{\"data\": {\"type\": \"FIX\"}}"
           }}
        end
      )
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: "https://web.test.bbcx-internal.com/news/uk-87654321"
           },
           :BBCX ->
          {:ok,
           %HTTP.Response{
             status_code: 200,
             body: "<h1>Hello from BBCX!</h1>"
           }}
        end
      )

      conn =
        conn(:get, "/news/uk-87654321")
        |> put_req_header("cookie-ckns_bbccom_beta", "1")
        |> put_req_header("x-bbc-edge-host", "www.bbc.com")
        |> put_req_header("x-country", "us")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert {200, _headers, "<h1>Hello from BBCX!</h1>"} = sent_resp(conn)
    end
  end

  describe "News article route behaviour on Bruce" do
    setup do
      set_stack_id("bruce")
      :ok
    end

    test "when asset type is a Web Core asset and Ares dial on" do
      fabl_url = "#{@fabl_endpoint}/module/ares-asset-identifier?path=%2Fnews%2Fuk-87654321"

      HTTPMock
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: ^fabl_url
           },
           :Preflight ->
          {:ok,
           %HTTP.Response{
             status_code: 200,
             body: "{\"data\": {\"type\": \"STY\"}}"
           }}
        end
      )

      expect(LambdaMock, :call, fn _credentials, _arn, _request, _ ->
        {:ok,
         %{
           "headers" => %{},
           "statusCode" => 200,
           "body" => "<h1>Hello from the Lambda!</h1>"
         }}
      end)

      conn =
        conn(:get, "/news/uk-87654321")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert {200, _headers, "<h1>Hello from the Lambda!</h1>"} = sent_resp(conn)
    end

    test "when asset type is a Mozart asset and Ares dial on" do
      fabl_url = "#{@fabl_endpoint}/module/ares-asset-identifier?path=%2Fnews%2Fuk-87654321"

      HTTPMock
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: ^fabl_url
           },
           :Preflight ->
          {:ok,
           %HTTP.Response{
             status_code: 200,
             body: "{\"data\": {\"type\": \"FIX\"}}"
           }}
        end
      )

      mozart_url = "#{@mozart_news_endpoint}#{@path}"

      HTTPMock
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: ^mozart_url
           },
           :MozartNews ->
          {:ok,
           %HTTP.Response{
             status_code: 200,
             body: "<h1>Hello from MozartNews!</h1>"
           }}
        end
      )

      conn =
        conn(:get, "/news/uk-87654321")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert {200, _headers, "<h1>Hello from MozartNews!</h1>"} = sent_resp(conn)
    end

    # At some point this will raise for a fallback when there is a data error
    test "when asset type is unknown due to a data error and Ares dial on" do
      fabl_url = "#{@fabl_endpoint}/module/ares-asset-identifier?path=%2Fnews%2Fuk-87654321"

      HTTPMock
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: ^fabl_url
           },
           :Preflight ->
          {:ok,
           %HTTP.Response{
             status_code: 500
           }}
        end
      )

      expect(LambdaMock, :call, fn _credentials, _arn, _request, _ ->
        {:ok,
         %{
           "headers" => %{},
           "statusCode" => 200,
           "body" => "<h1>Hello from the Lambda!</h1>"
         }}
      end)

      conn =
        conn(:get, "/news/uk-87654321")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert {200, _headers, "<h1>Hello from the Lambda!</h1>"} = sent_resp(conn)
    end

    test "when asset type is a Web Core asset and Ares dial set to logging mode" do
      stub_dial(:preflight_ares_data_fetch, "learning")

      fabl_url = "#{@fabl_endpoint}/module/ares-asset-identifier?path=%2Fnews%2Fuk-87654321"

      HTTPMock
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: ^fabl_url
           },
           :Preflight ->
          {:ok,
           %HTTP.Response{
             status_code: 200,
             body: "{\"data\": {\"type\": \"STY\"}}"
           }}
        end
      )

      expect(LambdaMock, :call, fn _credentials, _arn, _request, _ ->
        {:ok,
         %{
           "headers" => %{},
           "statusCode" => 200,
           "body" => "<h1>Hello from the Lambda!</h1>"
         }}
      end)

      conn =
        conn(:get, "/news/uk-87654321")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert {200, _headers, "<h1>Hello from the Lambda!</h1>"} = sent_resp(conn)
    end

    test "when asset type is a Mozart asset and Ares dial set to logging mode" do
      stub_dial(:preflight_ares_data_fetch, "learning")

      fabl_url = "#{@fabl_endpoint}/module/ares-asset-identifier?path=%2Fnews%2Fuk-87654321"

      HTTPMock
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: ^fabl_url
           },
           :Preflight ->
          {:ok,
           %HTTP.Response{
             status_code: 200,
             body: "{\"data\": {\"type\": \"FIX\"}}"
           }}
        end
      )

      expect(LambdaMock, :call, fn _credentials, _arn, _request, _ ->
        {:ok,
         %{
           "headers" => %{},
           "statusCode" => 200,
           "body" => "<h1>Hello from the Lambda!</h1>"
         }}
      end)

      conn =
        conn(:get, "/news/uk-87654321")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert {200, _headers, "<h1>Hello from the Lambda!</h1>"} = sent_resp(conn)
    end

    # At some point this will raise for a fallback when unable to fetch data
    test "when Ares dial disabled" do
      stub_dial(:preflight_ares_data_fetch, "off")

      expect(LambdaMock, :call, fn _credentials, _arn, _request, _ ->
        {:ok,
         %{
           "headers" => %{},
           "statusCode" => 200,
           "body" => "<h1>Hello from the Lambda!</h1>"
         }}
      end)

      conn =
        conn(:get, "/news/uk-87654321")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert {200, _headers, "<h1>Hello from the Lambda!</h1>"} = sent_resp(conn)
    end

    test "when asset type is a Web Core asset and Ares dial on and request is BBCX" do
      stub_dials(bbcx_enabled: "true")

      fabl_url = "#{@fabl_endpoint}/module/ares-asset-identifier?path=%2Fnews%2Fuk-87654321"

      HTTPMock
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: ^fabl_url
           },
           :Preflight ->
          {:ok,
           %HTTP.Response{
             status_code: 200,
             body: "{\"data\": {\"type\": \"STY\"}}"
           }}
        end
      )
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: "https://web.test.bbcx-internal.com/news/uk-87654321"
           },
           :BBCX ->
          {:ok,
           %HTTP.Response{
             status_code: 200,
             body: "<h1>Hello from BBCX!</h1>"
           }}
        end
      )

      conn =
        conn(:get, "/news/uk-87654321")
        |> put_req_header("cookie-ckns_bbccom_beta", "1")
        |> put_req_header("x-bbc-edge-host", "www.bbc.com")
        |> put_req_header("x-country", "us")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert {200, _headers, "<h1>Hello from BBCX!</h1>"} = sent_resp(conn)
    end

    test "when asset type is a Mozart asset and Ares dial on and request is BBCX" do
      stub_dials(bbcx_enabled: "true")

      fabl_url = "#{@fabl_endpoint}/module/ares-asset-identifier?path=%2Fnews%2Fuk-87654321"

      HTTPMock
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: ^fabl_url
           },
           :Preflight ->
          {:ok,
           %HTTP.Response{
             status_code: 200,
             body: "{\"data\": {\"type\": \"FIX\"}}"
           }}
        end
      )
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: "https://web.test.bbcx-internal.com/news/uk-87654321"
           },
           :BBCX ->
          {:ok,
           %HTTP.Response{
             status_code: 200,
             body: "<h1>Hello from BBCX!</h1>"
           }}
        end
      )

      conn =
        conn(:get, "/news/uk-87654321")
        |> put_req_header("cookie-ckns_bbccom_beta", "1")
        |> put_req_header("x-bbc-edge-host", "www.bbc.com")
        |> put_req_header("x-country", "us")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert {200, _headers, "<h1>Hello from BBCX!</h1>"} = sent_resp(conn)
    end
  end

  describe "News article route behaviour on Sally - any non-Bruce/Joan stack" do
    setup do
      set_stack_id("sally")
      :ok
    end

    test "when asset type is a Web Core asset and Ares dial on" do
      fabl_url = "#{@fabl_endpoint}/module/ares-asset-identifier?path=%2Fnews%2Fuk-87654321"

      HTTPMock
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: ^fabl_url
           },
           :Preflight ->
          {:ok,
           %HTTP.Response{
             status_code: 200,
             body: "{\"data\": {\"type\": \"STY\"}}"
           }}
        end
      )

      expect(LambdaMock, :call, fn _credentials, _arn, _request, _ ->
        {:ok,
         %{
           "headers" => %{},
           "statusCode" => 200,
           "body" => "<h1>Hello from the Lambda!</h1>"
         }}
      end)

      conn =
        conn(:get, "/news/uk-87654321")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert {200, _headers, "<h1>Hello from the Lambda!</h1>"} = sent_resp(conn)
    end

    test "when asset type is a Mozart asset and Ares dial on" do
      fabl_url = "#{@fabl_endpoint}/module/ares-asset-identifier?path=%2Fnews%2Fuk-87654321"

      HTTPMock
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: ^fabl_url
           },
           :Preflight ->
          {:ok,
           %HTTP.Response{
             status_code: 200,
             body: "{\"data\": {\"type\": \"FIX\"}}"
           }}
        end
      )

      mozart_url = "#{@mozart_news_endpoint}#{@path}"

      HTTPMock
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: ^mozart_url
           },
           :MozartNews ->
          {:ok,
           %HTTP.Response{
             status_code: 200,
             body: "<h1>Hello from MozartNews!</h1>"
           }}
        end
      )

      conn =
        conn(:get, "/news/uk-87654321")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert {200, _headers, "<h1>Hello from MozartNews!</h1>"} = sent_resp(conn)
    end

    # At some point this will raise for a fallback when there is a data error
    test "when asset type is unknown due to a data error and Ares dial on" do
      fabl_url = "#{@fabl_endpoint}/module/ares-asset-identifier?path=%2Fnews%2Fuk-87654321"

      HTTPMock
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: ^fabl_url
           },
           :Preflight ->
          {:ok,
           %HTTP.Response{
             status_code: 500
           }}
        end
      )

      expect(LambdaMock, :call, fn _credentials, _arn, _request, _ ->
        {:ok,
         %{
           "headers" => %{},
           "statusCode" => 200,
           "body" => "<h1>Hello from the Lambda!</h1>"
         }}
      end)

      conn =
        conn(:get, "/news/uk-87654321")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert {200, _headers, "<h1>Hello from the Lambda!</h1>"} = sent_resp(conn)
    end

    test "when asset type is a Web Core asset and Ares dial set to logging mode" do
      stub_dial(:preflight_ares_data_fetch, "learning")

      fabl_url = "#{@fabl_endpoint}/module/ares-asset-identifier?path=%2Fnews%2Fuk-87654321"

      HTTPMock
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: ^fabl_url
           },
           :Preflight ->
          {:ok,
           %HTTP.Response{
             status_code: 200,
             body: "{\"data\": {\"type\": \"STY\"}}"
           }}
        end
      )

      expect(LambdaMock, :call, fn _credentials, _arn, _request, _ ->
        {:ok,
         %{
           "headers" => %{},
           "statusCode" => 200,
           "body" => "<h1>Hello from the Lambda!</h1>"
         }}
      end)

      conn =
        conn(:get, "/news/uk-87654321")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert {200, _headers, "<h1>Hello from the Lambda!</h1>"} = sent_resp(conn)
    end

    test "when asset type is a Mozart asset and Ares dial set to logging mode" do
      stub_dial(:preflight_ares_data_fetch, "learning")

      fabl_url = "#{@fabl_endpoint}/module/ares-asset-identifier?path=%2Fnews%2Fuk-87654321"

      HTTPMock
      |> expect(
        :execute,
        fn %HTTP.Request{
             method: :get,
             url: ^fabl_url
           },
           :Preflight ->
          {:ok,
           %HTTP.Response{
             status_code: 200,
             body: "{\"data\": {\"type\": \"FIX\"}}"
           }}
        end
      )

      expect(LambdaMock, :call, fn _credentials, _arn, _request, _ ->
        {:ok,
         %{
           "headers" => %{},
           "statusCode" => 200,
           "body" => "<h1>Hello from the Lambda!</h1>"
         }}
      end)

      conn =
        conn(:get, "/news/uk-87654321")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert {200, _headers, "<h1>Hello from the Lambda!</h1>"} = sent_resp(conn)
    end

    # At some point this will raise for a fallback when unable to fetch data
    test "when Ares dial disabled" do
      stub_dial(:preflight_ares_data_fetch, "off")

      expect(LambdaMock, :call, fn _credentials, _arn, _request, _ ->
        {:ok,
         %{
           "headers" => %{},
           "statusCode" => 200,
           "body" => "<h1>Hello from the Lambda!</h1>"
         }}
      end)

      conn =
        conn(:get, "/news/uk-87654321")
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert {200, _headers, "<h1>Hello from the Lambda!</h1>"} = sent_resp(conn)
    end
  end

  test "when asset type is a Web Core asset and Ares dial on and request is BBCX" do
    stub_dials(bbcx_enabled: "true")

    fabl_url = "#{@fabl_endpoint}/module/ares-asset-identifier?path=%2Fnews%2Fuk-87654321"

    HTTPMock
    |> expect(
      :execute,
      fn %HTTP.Request{
           method: :get,
           url: ^fabl_url
         },
         :Preflight ->
        {:ok,
         %HTTP.Response{
           status_code: 200,
           body: "{\"data\": {\"type\": \"STY\"}}"
         }}
      end
    )
    |> expect(
      :execute,
      fn %HTTP.Request{
           method: :get,
           url: "https://web.test.bbcx-internal.com/news/uk-87654321"
         },
         :BBCX ->
        {:ok,
         %HTTP.Response{
           status_code: 200,
           body: "<h1>Hello from BBCX!</h1>"
         }}
      end
    )

    conn =
      conn(:get, "/news/uk-87654321")
      |> put_req_header("cookie-ckns_bbccom_beta", "1")
      |> put_req_header("x-bbc-edge-host", "www.bbc.com")
      |> put_req_header("x-country", "us")
      |> Router.call(routefile: Routes.Routefiles.Main.Live)

    assert {200, _headers, "<h1>Hello from BBCX!</h1>"} = sent_resp(conn)
  end

  test "when asset type is a Mozart asset and Ares dial on and request is BBCX" do
    stub_dials(bbcx_enabled: "true")

    fabl_url = "#{@fabl_endpoint}/module/ares-asset-identifier?path=%2Fnews%2Fuk-87654321"

    HTTPMock
    |> expect(
      :execute,
      fn %HTTP.Request{
           method: :get,
           url: ^fabl_url
         },
         :Preflight ->
        {:ok,
         %HTTP.Response{
           status_code: 200,
           body: "{\"data\": {\"type\": \"FIX\"}}"
         }}
      end
    )
    |> expect(
      :execute,
      fn %HTTP.Request{
           method: :get,
           url: "https://web.test.bbcx-internal.com/news/uk-87654321"
         },
         :BBCX ->
        {:ok,
         %HTTP.Response{
           status_code: 200,
           body: "<h1>Hello from BBCX!</h1>"
         }}
      end
    )

    conn =
      conn(:get, "/news/uk-87654321")
      |> put_req_header("cookie-ckns_bbccom_beta", "1")
      |> put_req_header("x-bbc-edge-host", "www.bbc.com")
      |> put_req_header("x-country", "us")
      |> Router.call(routefile: Routes.Routefiles.Main.Live)

    assert {200, _headers, "<h1>Hello from BBCX!</h1>"} = sent_resp(conn)
  end
end
