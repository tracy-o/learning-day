defmodule BelfrageWeb.Plugs.HttpRedirector do
  import Plug.Conn
  alias Belfrage.Helpers.QueryParams

  @moduledoc """
  Redirects a request with a http scheme
  to one with a https scheme.
  """

  def init(opts), do: opts

  def call(conn, _opts) do
    if is_insecure?(get_req_header(conn, "x-bbc-edge-scheme")) and
         is_bbc_domain?(get_req_header(conn, "x-bbc-edge-host")) do
      redirect(conn)
    else
      conn
    end
  end

  defp redirect(conn) do
    conn
    |> put_resp_header("location", set_location(conn))
    |> put_resp_header("via", "1.1 Belfrage")
    |> put_resp_header("server", "Belfrage")
    |> put_resp_header("x-bbc-no-scheme-rewrite", "1")
    |> put_resp_header("req-svc-chain", conn.private.bbc_headers.req_svc_chain)
    |> put_resp_header("cache-control", "public, stale-while-revalidate=10, max-age=60")
    |> put_resp_header("vary", "x-bbc-edge-scheme")
    |> send_resp(302, "")
    |> halt()
  end

  defp set_location(conn = %Plug.Conn{query_params: %Plug.Conn.Unfetched{aspect: :query_params}}) do
    "https://" <> conn.host <> conn.request_path
  end

  defp set_location(conn) do
    "https://" <> conn.host <> conn.request_path <> QueryParams.encode(conn.query_params)
  end

  defp is_insecure?(["http"]), do: true
  defp is_insecure?(_), do: false

  # This is to allow vanity url redirects in the routefiles
  defp is_bbc_domain?([host]) do
    String.ends_with?(host, ".bbc.com") or String.ends_with?(host, ".bbc.co.uk")
  end
end
