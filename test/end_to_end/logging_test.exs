defmodule EndToEnd.LoggingTest do
  @moduledoc """
  This file contains generic end-to-end tests. It merges the old e2e test
  and a new one, which aims to test the generation of the `access.log` file

  """
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  import Belfrage.Test.CachingHelper
  import ExUnit.CaptureLog

  alias BelfrageWeb.Router
  alias Belfrage.Clients.LambdaMock

  @moduletag :end_to_end

  setup :clear_cache

  describe "generic e2e tests - router call" do
    test "requests are logged" do
      stub(LambdaMock, :call, fn _role_arn, _function_arn, _request, _opts ->
        {:ok,
         %{
           "headers" => %{
             "access-log-res-header" => "yes",
             "ssl" => "ssl-value",
             "set-cookie" => "session=12345"
           },
           "statusCode" => 200,
           "body" => "OK"
         }}
      end)

      captured_log =
        capture_log(fn ->
          conn(:get, "/200-ok-response?query=querystring")
          |> put_req_header("authorization", "auth-heaader-value")
          |> put_req_header("access-log-req-header", "yes")
          |> Router.call([])
        end)

      assert captured_log =~ "query=querystring", "Failed to log querystring"
      assert captured_log =~ "/200-ok-response", "Failed to log request path"
      assert captured_log =~ "200", "Failed to log response status code"
      assert captured_log =~ "GET", "Failed to log request method"
      assert captured_log =~ "access-log-res-header", "Failed to log response headers"
      assert captured_log =~ "access-log-req-header", "Failed to log request headers"
      assert captured_log =~ "set-cookie", "Should keep header keys relating to cookies"
      assert captured_log =~ "ssl", "Should keep header keys relating to SSL"

      assert count_words(captured_log, "REDACTED") == 3,
             "Failed to replace cookie and ssl values from header"

      refute captured_log =~ "session=12345", "Cookie value still present in log"
      refute captured_log =~ "ssl-value", "SSL value still present in log"

      refute captured_log =~ "auth-header-value",
             ~s("authorization" request header value still present in log)
    end

    defp count_words(string, word) do
      Regex.scan(~r/#{word}/i, string) |> length()
    end
  end

  describe "e2e tests for access log generation" do
    test "requests are logged" do
      :erlang.trace(:all, true, [:call])
      :erlang.trace_pattern({IO, :write, 2}, true, [:local])

      stub(LambdaMock, :call, fn _role_arn, _function_arn, _request, _opts ->
        {:ok,
         %{
           "headers" => %{
             "access-log-res-header" => "yes",
             "ssl" => "ssl-value",
             "set-cookie" => "session=12345"
           },
           "statusCode" => 200,
           "body" => "OK"
         }}
      end)

      :get
      |> conn("/status?foo=bar")
      |> put_req_header("x-bbc-edge-host", "my-host")
      |> put_req_header("authorization", "auth-heaader-value")
      |> put_req_header("access-log-req-header", "yes")
      |> put_req_header("x-bbc-request-id", "bbc-id-1234")
      |> put_req_header("x-bbc-edge-scheme", "https")
      |> put_resp_header("bsig", "bsig-1234")
      |> put_resp_header("belfrage-cache-status", "cache-status")
      |> put_resp_header("content-length", "1234")
      |> put_resp_header("bid", "bid-1234")
      |> put_resp_header("location", "https://my-location")
      |> put_resp_header("req-svc-chain", "GTM,BELFRAGE,MOZART")
      |> put_resp_header("vary", "vary-1234")
      |> Router.call([])

      assert_receive {:trace, _, :call, {IO, :write, [_pid, [event]]}}

      assert [
               timestamp,
               "GET",
               "https",
               "my-host",
               "/status",
               "foo=bar",
               "200",
               "GTM,BELFRAGE,MOZART",
               "bbc-id-1234",
               "bsig-1234",
               "bid-1234",
               "cache-status",
               "max-age=0, private, must-revalidate",
               "vary-1234",
               "1234",
               "https://my-location\"\n"
             ] = String.split(event, "\" \"")

      sanitised_timestamp = String.replace(timestamp, "\"", "")
      assert {:ok, _, _} = DateTime.from_iso8601(sanitised_timestamp)
    end
  end
end
