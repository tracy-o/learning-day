defmodule Benchmark.AccessLogs do
  @moduledoc """
  Comparing parts of the Access Logs Plug

  This benchmark measures the performance of implementations.

  ### To run this experiment
  ```
        $ mix benchmark access_logs
  ```
  """
  require Logger

  import Plug.Conn
  import Plug.Test, only: [conn: 2]

  alias Belfrage.Logger.HeaderRedactor

  # @redacted_headers_regex Enum.join(["cookie", "ssl", "content-security-policy", "feature-policy", "report-to"], "|")
  # @redacted_headers_regex Regex.compile!(["cookie", "ssl", "content-security-policy", "feature-policy", "report-to"])
  @redacted_headers_regex Regex.compile!(
                            Enum.join(["cookie", "ssl", "content-security-policy", "feature-policy", "report-to"], "|")
                          )
  @redacted_headers ["cookie", "ssl", "content-security-policy", "feature-policy", "report-to"]

  def run(_) do
    {:ok, _started} = Application.ensure_all_started(:belfrage)
    experiment()
  end

  def experiment(_iterations \\ 1000) do
    conn =
      conn(
        :get,
        "/afrique/bbc_afrique_radio/schedule.json"
      )
      |> put_status(200)
      |> put_req_header("x-ip_is_uk_combined", "no")
      |> put_req_header("x-ssl-session-reused", "REDACTED")
      |> put_req_header("x-host", "www.test.bbc.com")
      |> put_req_header("x-server-protocol", "HTTP/1.1")
      |> put_req_header("x-ip_carrier", "amazon technologies inc.")
      |> put_req_header("x-ip_is_advertise_combined", "yes")
      |> put_req_header("sslsessionid", "REDACTED")
      |> put_req_header("x-ssl-server-name", "REDACTED")
      |> put_req_header("x-id-oidc-signedin", "0")
      |> put_req_header("req-svc-chain", "GTM")
      |> put_req_header("host", "www.test.bbc.com")
      |> put_req_header("x-bbc-edge-cache", "1")
      |> put_req_header("x-cluster-client-ip", "52.209.72.228")
      |> put_req_header("x-bbc-edge-remote-addr", "52.209.72.228")
      |> put_req_header("x-country", "ie")
      |> put_req_header("x-ssl-cipher", "REDACTED")
      |> put_req_header("x-bbc-edge-isuk", "no")
      |> put_req_header("x-ip_asn", "16509")
      |> put_req_header("user-agent", "node-fetch/1.0 (+https://github.com/bitinn/node-fetch)")
      |> put_req_header("x-bbc-edge-country", "ie")
      |> put_req_header("accept-encoding", "gzip,deflate")
      |> put_req_header("x-bbc-request-id", "ae275035d2d01ccd424c865e6f8f3ed9")
      |> put_req_header("x-bbc-edge-client-ip", "52.209.72.228")
      |> put_req_header("x-ssl-protocol", "REDACTED")
      |> put_req_header("x-bbc-edge-host", "www.test.bbc.com")
      |> put_req_header("x-ip_is_proxy", "no")
      |> put_req_header("x-bbc-edge-isfastly", "0")
      |> put_req_header("x-bbc-edge-scheme", "https")
      |> put_req_header("x-ip_is_eu_combined", "yes")
      |> put_req_header("accept", "*/*")
      |> put_req_header("sslclientcertstatus", "REDACTED")
      |> put_req_header("x-forwarded-proto", "https")
      |> put_req_header("x-tcpinfo-rtt", "969")
      |> put_req_header("x-request-id", "ae275035d2d01ccd424c865e6f8f3ed9")
      |> put_resp_header(
        "belfrage-pipeline-trail",
        "DevelopmentRequests,CircuitBreaker,WorldServiceRedirect,TrailingSlashRedirector,HTTPredirect"
      )
      |> put_resp_header("routespec", "WorldServiceAfrique")
      |> put_resp_header("belfrage-cache-status", "MISS")
      |> put_resp_header("brequestid", "93b1a4d6c7444c329c8adddb68e3fa09")
      |> put_resp_header("via", "1.1 Belfrage")
      |> put_resp_header("bid", "sally")
      |> put_resp_header("bsig", "0594cc1199ef047ec1912973c1b20418")
      |> put_resp_header("x-msig", "ba0e60ffd14472e9144942dee97eb5a0")
      |> put_resp_header("x-mrid", "n1")
      |> put_resp_header("x-frame-options", "SAMEORIGIN")
      |> put_resp_header("x-content-type-options", "nosniff")
      |> put_resp_header(
        "vary",
        "Accept-Encoding,X-BBC-Edge-Cache,X-BBC-Edge-Country,X-BBC-Edge-IsUK,X-BBC-Edge-Scheme"
      )
      |> put_resp_header("server", "Belfrage")
      |> put_resp_header("req-svc-chain", "GTM,BELFRAGE,MOZART,ARES")
      |> put_resp_header("moz-cache-status", "HIT")
      |> put_resp_header("date", "Fri, 04 Feb 2022 12:27:27 GMT")
      |> put_resp_header("content_type", "application/json")
      |> put_resp_header("content-type", "application/json")
      |> put_resp_header("content-length", "16")
      |> put_resp_header("content-encoding", "gzip")
      |> put_resp_header("cache-control", "public, stale-if-error=90, stale-while-revalidate=30, max-age=30")

    Benchee.run(
      %{
        "record" => fn -> record(conn) end,
        "req_headers" => fn -> HeaderRedactor.redact(conn.req_headers) end,
        "resp_headers" => fn -> HeaderRedactor.redact(conn.resp_headers) end,
        # "Enum.map" => fn -> Enum.map(conn.req_headers, &maybe_redact/1) end,
        # "for" => fn -> for {k, v} <- conn.req_headers, into: %{}, do: maybe_redact({k, v}) end,
        # "Enum.reduce" => fn -> Enum.reduce(conn.req_headers, %{}, fn {k, v} -> maybe_redact_regex({k, v}) end) end,
        "String.contains?" => fn -> Enum.map(conn.req_headers, &maybe_redact_string_contains/1) end,
        "Match regex" => fn -> Enum.map(conn.req_headers, &maybe_redact_match_regex/1) end,
        "Match regex Enum.any?" => fn -> Enum.map(conn.req_headers, &maybe_redact_match_regex_enum_any/1) end,
        "String.contains? Enum.any?" => fn -> Enum.map(conn.req_headers, &maybe_redact_string_contains_enum_any/1) end,
        "Match binary" => fn -> Enum.map(conn.req_headers, &maybe_redact_match_binary/1) end,
        "Match binary Enum.any?" => fn -> Enum.map(conn.req_headers, &maybe_redact_match_binary_enum_any/1) end
      },
      time: 10,
      memory_time: 2
    )
  end

  defp record(conn) do
    Logger.log(:info, "", %{
      path: conn.request_path,
      status: conn.status,
      method: conn.method,
      req_headers: HeaderRedactor.redact(conn.req_headers),
      resp_headers: HeaderRedactor.redact(conn.resp_headers)
    })
  end

  defp maybe_redact_string_contains({key, value}) do
    case String.contains?(key, @redacted_headers) do
      true -> {key, "REDACTED"}
      false -> {key, value}
    end
  end

  defp maybe_redact_match_regex({key, value}) do
    if IO.iodata_to_binary(key) =~ @redacted_headers_regex do
      {key, "REDACTED"}
    else
      {key, value}
    end
  end

  defp maybe_redact_match_regex_enum_any({key, value}) do
    if Enum.any?(@redacted_headers, fn header ->
         IO.iodata_to_binary(key) =~ header
       end) do
      {key, "REDACTED"}
    else
      {key, value}
    end
  end

  defp maybe_redact_string_contains_enum_any({key, value}) do
    case Enum.any?(@redacted_headers, &String.contains?(key, &1)) do
      true -> {key, "REDACTED"}
      false -> {key, value}
    end
  end

  defp maybe_redact_match_binary({key, value}) do
    case :binary.match(key, @redacted_headers) do
      :nomatch -> {key, value}
      _ -> {key, "REDACTED"}
    end
  end

  defp maybe_redact_match_binary_enum_any({key, value}) do
    case Enum.any?(@redacted_headers, fn header ->
           :binary.match(key, header) != :nomatch
         end) do
      true -> {key, "REDACTED"}
      false -> {key, value}
    end
  end
end
