defmodule BelfrageWeb.Logger.AccessLoggerTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Plugs.AccessLogger

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

      # Complete assetions
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
               "bbc-id-1234",
               "https",
               "my-host",
               "GET",
               "/news",
               "foo=bar",
               "200",
               "bsig-1234",
               "cache-status",
               "max-age=0, private, must-revalidate",
               "1234",
               "bid-1234",
               "https://my-location",
               "GTM,BELFRAGE,MOZART",
               "vary-1234\"\n"
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
               "bbc-id-1234",
               "https",
               "my-host",
               "GET",
               "/news",
               "foo=bar",
               "200",
               "bsig-1234",
               "cache-status",
               "max-age=0, private, must-revalidate",
               "1234",
               "bid-1234",
               "https://my-location",
               "GTM,BELFRAGE,MOZART",
               "vary-1234\"\n"
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
               "bbc-id-1234",
               "https",
               "my-host",
               "GET",
               "/news",
               "foo=bar",
               "200",
               "bsig-1234",
               "cache-status",
               "max-age=0, private, must-revalidate",
               "",
               "bid-1234",
               "https://my-location",
               "GTM,BELFRAGE,MOZART",
               "vary-1234\"\n"
             ] = String.split(event, "\" \"")

      sanitised_timestamp = String.trim(timestamp, "\"")
      assert {:ok, _, _} = DateTime.from_iso8601(sanitised_timestamp)
    end

    test "multiple headers scenario", %{conn: conn} do
      conn = Map.put(conn, :resp_headers, conn.resp_headers ++ [{"vary", "Accept1"}, {"vary", "Accept2"}])
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

  defp generate_conn_object do
    bbc_headers = %{
      scheme: :https,
      host: "my-host",
      req_svc_chain: "GTM,BELFRAGE,MOZART"
    }

    :get
    |> conn("/")
    |> Map.put(:host, "example.com")
    |> Map.put(:request_path, "/news")
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
end
