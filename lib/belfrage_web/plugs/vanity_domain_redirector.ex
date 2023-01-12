defmodule BelfrageWeb.Plugs.VanityDomainRedirector do
  import Plug.Conn

  @redirects %{
    "www.bbcafaanoromoo.com" => "https://www.bbc.com/afaanoromoo",
    "www.bbcafrique.com" => "https://www.bbc.com/afrique",
    "www.bbcarabic.com" => "https://www.bbc.com/arabic",
    "m.bbcarabic.com" => "https://www.bbc.com/arabic",
    "bbcarabic.com" => "https://www.bbc.com/arabic"
  }

  def init(opts), do: opts

  def call(conn = %{host: host}, _opts) when is_map_key(@redirects, host) do
    redirect(conn)
  end

  def call(conn, _opts) do
    conn
  end

  defp redirect(conn) do
    conn
    |> put_resp_header("location", @redirects[conn.host] <> set_location(conn))
    |> put_resp_header("via", "1.1 Belfrage")
    |> put_resp_header("server", "Belfrage")
    |> put_resp_header("x-bbc-no-scheme-rewrite", "1")
    |> put_resp_header("req-svc-chain", conn.private.bbc_headers.req_svc_chain)
    |> put_resp_header("cache-control", "public, stale-while-revalidate=10, max-age=60")
    |> put_resp_header("vary", "x-bbc-edge-scheme")
    |> send_resp(302, "")
    |> halt()
  end

  def set_location(_conn = %{request_path: nil}), do: ""
  def set_location(_conn = %{request_path: "/"}), do: ""
  def set_location(_conn = %{request_path: request_path}), do: request_path
end
