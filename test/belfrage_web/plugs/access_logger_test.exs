defmodule BelfrageWeb.Logger.AccessLoggerTest do
  use ExUnit.Case
  use Plug.Test

  alias BelfrageWeb.Router
  alias BelfrageWeb.Plugs.AccessLogger

  use Test.Support.Helper, :mox

  describe "call/2" do
    setup do
      {:ok, conn: generate_conn_object()}
    end

    test "expected message is sent to the FileLoggerBackend event handler", %{conn: conn} do
      :erlang.trace(:all, true, [:call])
      :erlang.trace_pattern({LoggerFileBackend, :handle_event, 2}, true, [:local])

      conn
      |> AccessLogger.call(:info)
      |> resp(200, "")
      |> send_resp()

      assert_receive {:trace, _, :call,
                      {LoggerFileBackend, :handle_event,
                       [
                         {_level, _, {Logger, "", _datetime, metadata}},
                         _config
                       ]}}

      assert Keyword.get(metadata, :access)
      assert Keyword.get(metadata, :method) == "GET"
      assert Keyword.get(metadata, :query_string) == "foo=bar"
      assert Keyword.get(metadata, :request_path) == "/news"
      assert Keyword.get(metadata, :status) == 200
    end

    test "expected write is attempted", %{conn: conn} do
      :erlang.trace(:all, true, [:call])
      :erlang.trace_pattern({IO, :write, 2}, true, [:local])

      conn
      |> AccessLogger.call(:info)
      |> resp(200, "")
      |> send_resp()

      assert_receive {:trace, _, :call, {IO, :write, [_pid, [event]]}}

      assert [
               timestamp,
               "GET",
               "https",
               "my-host",
               "/news",
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

      sanitised_timestamp = String.trim(timestamp, "\"")
      assert {:ok, _, _} = DateTime.from_iso8601(sanitised_timestamp)
    end

    test "missing scheme - https is injected by the Sanitiser", %{conn: conn} do
      :erlang.trace(:all, true, [:call])
      :erlang.trace_pattern({IO, :write, 2}, true, [:local])

      conn
      |> AccessLogger.call(:info)
      |> resp(200, "")
      |> send_resp()

      assert_receive {:trace, _, :call, {IO, :write, [_pid, [event]]}}

      assert [
               timestamp,
               "GET",
               "https",
               "my-host",
               "/news",
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

      sanitised_timestamp = String.trim(timestamp, "\"")
      assert {:ok, _, _} = DateTime.from_iso8601(sanitised_timestamp)
    end

    test "missing content-length", %{conn: conn} do
      :erlang.trace(:all, true, [:call])
      :erlang.trace_pattern({IO, :write, 2}, true, [:local])

      conn
      |> delete_resp_header("content-length")
      |> AccessLogger.call(:info)
      |> resp(200, "")
      |> send_resp()

      assert_receive {:trace, _, :call, {IO, :write, [_pid, [event]]}}

      assert [
               timestamp,
               "GET",
               "https",
               "my-host",
               "/news",
               "foo=bar",
               "200",
               "GTM,BELFRAGE,MOZART",
               "bbc-id-1234",
               "bsig-1234",
               "bid-1234",
               "cache-status",
               "max-age=0, private, must-revalidate",
               "vary-1234",
               "",
               "https://my-location\"\n"
             ] = String.split(event, "\" \"")

      sanitised_timestamp = String.trim(timestamp, "\"")
      assert {:ok, _, _} = DateTime.from_iso8601(sanitised_timestamp)
    end

    test "multiple headers scenario", %{conn: conn} do
      conn =
        Map.put(
          conn,
          :resp_headers,
          conn.resp_headers ++ [{"vary", "Accept1"}, {"vary", "Accept2"}]
        )

      :erlang.trace(:all, true, [:call])
      :erlang.trace_pattern({LoggerFileBackend, :handle_event, 2}, true, [:local])

      conn
      |> AccessLogger.call(:info)
      |> resp(200, "")
      |> send_resp()

      assert_receive {:trace, _, :call,
                      {LoggerFileBackend, :handle_event,
                       [
                         {_level, _, {Logger, "", _datetime, metadata}},
                         _config
                       ]}}

      assert metadata |> Keyword.get(:vary) =~ "Accept1,Accept2"
    end
  end

  defp generate_conn_object(request_path \\ "/news") do
    bbc_headers = %{
      scheme: :https,
      host: "my-host",
      req_svc_chain: "GTM,BELFRAGE,MOZART"
    }

    :get
    |> conn("/")
    |> Map.put(:host, "example.com")
    |> Map.put(:request_path, request_path)
    |> Map.put(:query_string, "foo=bar")
    |> put_private(:bbc_headers, bbc_headers)
    |> put_req_header("x-bbc-request-id", "bbc-id-1234")
    |> put_req_header("x-bbc-edge-scheme", "https")
    |> put_resp_header("bsig", "bsig-1234")
    |> put_resp_header("belfrage-cache-status", "cache-status")
    |> put_resp_header("cache-control", "max-age=0, private, must-revalidate")
    |> put_resp_header("content-length", "1234")
    |> put_resp_header("bid", "bid-1234")
    |> put_resp_header("req-svc-chain", "GTM,BELFRAGE,MOZART")
    |> put_resp_header("location", "https://my-location")
    |> put_resp_header("vary", "vary-1234")
    |> put_resp_header("ssl", "i_should_be_filtered")
    |> put_resp_header("set-cookie", "i_should_be_filtered")
  end

  describe "redirect scenarios" do
    test "301 logged in access.log  when TrailingSlashRedirector is executed" do
      :erlang.trace(:all, true, [:call])
      :erlang.trace_pattern({IO, :write, 2}, true, [:local])

      :get
      |> conn("/news/")
      |> Router.call(routefile: Routes.Routefiles.Mock)

      assert_receive {:trace, _, :call, {IO, :write, [_pid, [event]]}}

      assert [
               _timestamp,
               _method,
               _scheme,
               _host,
               _request_path,
               _query_string,
               "301",
               _req_svc_chain,
               _bbc_request_id,
               _bsig,
               _bid,
               _belfrage_cache_status,
               _cache_control,
               _vary,
               _content_length,
               "/news\"\n"
             ] = String.split(event, "\" \"")
    end

    test "302 logged in access.log when VanityDomainRedirector is executed" do
      :erlang.trace(:all, true, [:call])
      :erlang.trace_pattern({IO, :write, 2}, true, [:local])

      :get
      |> conn("/")
      |> Map.put(:host, "bbcafaanoromoo.com")
      |> Router.call(routefile: Routes.Routefiles.Mock)

      assert_receive {:trace, _, :call, {IO, :write, [_pid, [event]]}}

      assert [
               _timestamp,
               _method,
               _scheme,
               _host,
               _request_path,
               _query_string,
               "302",
               _req_svc_chain,
               _bbc_request_id,
               _bsig,
               _bid,
               _belfrage_cache_status,
               _cache_control,
               _vary,
               _content_length,
               "https://www.bbc.com/afaanoromoo\"\n"
             ] = String.split(event, "\" \"")
    end

    test "VarianceReducer and HttpRedirector plugs logging test" do
      :erlang.trace(:all, true, [:call])
      :erlang.trace_pattern({IO, :write, 2}, true, [:local])

      stub_dials(news_apps_variance_reducer: "enabled")
      path = "/fd/abl?clientName=Chrysalis&clientLoc=E7&type=index"

      :get
      |> conn(path)
      |> Map.put(:host, "www.test.bbc.co.uk")
      |> put_req_header("x-bbc-edge-scheme", "http")
      |> Router.call(routefile: Routes.Routefiles.Mock)

      assert_receive {:trace, _, :call, {IO, :write, [_pid, [event]]}}

      assert [
               _timestamp,
               _method,
               _scheme,
               _host,
               _request_path,
               _query_string,
               "302",
               _req_svc_chain,
               _bbc_request_id,
               _bsig,
               _bid,
               _belfrage_cache_status,
               _cache_control,
               _vary,
               _content_length,
               "https://www.test.bbc.co.uk/fd/abl?clientLoc=E7&clientName=Chrysalis&type=index\"\n"
             ] = String.split(event, "\" \"")
    end

    test "HeadPlug logging test" do
      :erlang.trace(:all, true, [:call])
      :erlang.trace_pattern({IO, :write, 2}, true, [:local])

      stub_dials(news_apps_variance_reducer: "enabled")
      path = "/news"

      :head
      |> conn(path)
      |> Map.put(:host, "www.test.bbc.co.uk")
      |> put_req_header("x-bbc-edge-scheme", "http")
      |> Router.call(routefile: Routes.Routefiles.Mock)

      assert_receive {:trace, _, :call, {IO, :write, [_pid, [event]]}}

      assert [
               _timestamp,
               "HEAD",
               _scheme,
               _host,
               _request_path,
               _query_string,
               "302",
               _req_svc_chain,
               _bbc_request_id,
               _bsig,
               _bid,
               _belfrage_cache_status,
               _cache_control,
               _vary,
               _content_length,
               "https://www.test.bbc.co.uk/news\"\n"
             ] = String.split(event, "\" \"")
    end

    test ~s(requests to "/status" are not sent to the FileLoggerBackend event handler) do
      :erlang.trace(:all, true, [:call])
      :erlang.trace_pattern({LoggerFileBackend, :handle_event, 2}, true, [:local])

      generate_conn_object("/status")
      |> AccessLogger.call(:info)
      |> resp(200, "")
      |> send_resp()

      refute_receive {:trace, _, :call,
                      {LoggerFileBackend, :handle_event,
                       [
                         {_level, _, {Logger, "", _datetime, _metadata}},
                         _config
                       ]}}
    end
  end

  test "handles infinite loop" do
    conn =
      :get
      |> conn("/news")
      |> Plug.Conn.put_req_header("req-svc-chain", "GTM,BELFRAGE,MOZART,BELFRAGE")
      |> Router.call(routefile: Routes.Routefiles.Mock)

    assert conn.status == 404
  end
end
