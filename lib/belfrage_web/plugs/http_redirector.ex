defmodule BelfrageWeb.Plugs.HttpRedirector do
  import Plug.Conn

  @moduledoc """
  Redirects a request with a http scheme
  to one with a https scheme.
  """

  def init(opts), do: opts

  def call(conn, _opts) do
    if is_insecure?(get_req_header(conn, "x-bbc-edge-scheme")) do
      redirect(conn)
    else
      conn
    end
  end

  defp redirect(conn) do
    conn
    |> set_location()
    |> put_resp_header("via", "1.1 Belfrage")
    |> put_resp_header("server", "Belfrage")
    |> put_resp_header("x-bbc-no-scheme-rewrite", "1")
    |> put_resp_header("req-svc-chain", conn.private.bbc_headers.req_svc_chain)
    |> put_resp_header("cache-control", "public, stale-while-revalidate=10, max-age=60")
    |> put_resp_header("vary", "accept-encoding,x-id-oidc-signedin,x-bbc-edge-scheme")
    |> send_resp(302, "")
    |> halt()
  end

  defp set_location(conn) do
    redirect_url = String.replace(request_url(conn), "http", "https", global: false)
    put_resp_header(conn, "location", redirect_url)
  end

  defp is_insecure?(["http"]), do: true
  defp is_insecure?(_), do: false
end
