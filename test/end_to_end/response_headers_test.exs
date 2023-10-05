defmodule EndToEnd.ResponseHeadersTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  import Belfrage.Test.CachingHelper

  alias BelfrageWeb.Router
  alias Belfrage.{Clients.LambdaMock, Envelope}

  @moduletag :end_to_end

  setup do
    clear_cache()
  end

  describe "default response headers" do
    test "200 response" do
      stub_webcore_response(status_code: 200)
      conn = call("/200-ok-response")

      assert conn.status == 200
      assert conn.resp_body == "OK"

      assert [
               {"cache-control", "private, stale-if-error=90, stale-while-revalidate=30"},
               {"content-type", "text/html; charset=utf-8"},
               {"vary",
                "Accept-Encoding,X-BBC-Edge-Cache,X-Country,X-IP_Is_UK_Combined,X-BBC-Edge-Scheme,cookie-ckns_bbccom_beta"},
               {"server", "Belfrage"},
               {"bsig", "16aa506c48f67bbbd845a5e4ac48b8f2"},
               {"bid", "local"},
               {"via", "1.1 Belfrage"},
               {"req-svc-chain", "BELFRAGE"},
               {"brequestid", _},
               {"belfrage-cache-status", "MISS"},
               {"routespec", "SomeRouteState.Webcore"},
               {"belfrage-request-pipeline-trail",
                "DevelopmentRequests,CircuitBreaker,IsCommercial,PlatformKillSwitch,Language,LambdaOriginAlias,PersonalisationGuardian,SessionState"},
               {"belfrage-response-pipeline-trail",
                "PreCacheCompression,CustomRssErrorResponse,ResponseHeaderGuardian,ClassicAppCacheControl,CacheDirective"}
             ] = conn.resp_headers
    end

    test "404 response" do
      conn = call("/premature-404")

      assert conn.status == 404
      assert conn.resp_body == "<h1>404 Page Not Found</h1>\n<!-- Belfrage -->"

      assert conn.resp_headers == [
               {"cache-control", "public, stale-if-error=90, stale-while-revalidate=60, max-age=30"},
               {"content-type", "text/html; charset=utf-8"},
               {"req-svc-chain", "BELFRAGE"},
               {"vary", "Accept-Encoding,X-BBC-Edge-Cache,X-Country,X-IP_Is_UK_Combined,X-BBC-Edge-Scheme"},
               {"server", "Belfrage"},
               {"bid", "local"},
               {"via", "1.1 Belfrage"},
               {"belfrage-cache-status", "MISS"}
             ]
    end

    test "405 response" do
      envelope = %Envelope{request: %Envelope.Request{req_svc_chain: "GTM"}}

      conn =
        conn(:post, "/search")
        |> assign(:envelope, envelope)
        |> Router.call(routefile: Routes.Routefiles.Main.Live)

      assert conn.status == 405
      assert conn.resp_body == "<h1>405 Not Supported</h1>\n<!-- Belfrage -->"

      assert conn.resp_headers == [
               {"cache-control", "public, stale-while-revalidate=15, max-age=5"},
               {"content-type", "text/html; charset=utf-8"},
               {"req-svc-chain", "GTM,BELFRAGE"},
               {"vary", "Accept-Encoding,X-BBC-Edge-Cache,X-Country,X-IP_Is_UK_Combined,X-BBC-Edge-Scheme"},
               {"server", "Belfrage"},
               {"bid", "local"},
               {"via", "1.1 Belfrage"},
               {"belfrage-cache-status", "MISS"}
             ]
    end

    test "500 response" do
      stub_webcore_response(status_code: 500)
      conn = call("/200-ok-response")

      assert conn.status == 500
      assert conn.resp_body == "OK"

      assert [
               {"cache-control", "private, stale-if-error=90, stale-while-revalidate=30"},
               {"content-type", "text/html; charset=utf-8"},
               {"vary",
                "Accept-Encoding,X-BBC-Edge-Cache,X-Country,X-IP_Is_UK_Combined,X-BBC-Edge-Scheme,cookie-ckns_bbccom_beta"},
               {"server", "Belfrage"},
               {"bsig", "16aa506c48f67bbbd845a5e4ac48b8f2"},
               {"bid", "local"},
               {"via", "1.1 Belfrage"},
               {"req-svc-chain", "BELFRAGE"},
               {"brequestid", _},
               {"belfrage-cache-status", "MISS"},
               {"routespec", "SomeRouteState.Webcore"},
               {"belfrage-request-pipeline-trail",
                "DevelopmentRequests,CircuitBreaker,IsCommercial,PlatformKillSwitch,Language,LambdaOriginAlias,PersonalisationGuardian,SessionState"},
               {"belfrage-response-pipeline-trail",
                "PreCacheCompression,CustomRssErrorResponse,ResponseHeaderGuardian,ClassicAppCacheControl,CacheDirective"}
             ] = conn.resp_headers
    end
  end

  defp stub_webcore_response(opts) do
    stub(LambdaMock, :call, fn _role_arn, _function_arn, _request, _opts ->
      {:ok,
       %{
         "headers" => %{
           "content-type" => "text/html; charset=utf-8",
           "cache-control" => "private"
         },
         "statusCode" => Keyword.get(opts, :status_code, 200),
         "body" => "OK"
       }}
    end)
  end

  def call(path) do
    conn(:get, path) |> Router.call(routefile: Routes.Routefiles.Mock)
  end
end
