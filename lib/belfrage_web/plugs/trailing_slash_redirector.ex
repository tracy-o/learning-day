defmodule BelfrageWeb.Plugs.TrailingSlashRedirector do
  import Plug.Conn

  @moduledoc """
  Redirects a request with
  a request path and a trailing slash
  to one without a trailing slash.
  """

  def init(opts), do: opts

  def call(conn, _opts) do
    if trailing_slash?(conn) do
      redirect(conn)
    else
      conn
    end
  end

  defp redirect(conn) do
    conn
    |> put_location()
    |> put_resp_content_type("text/plain")
    |> put_resp_header("server", "Belfrage")
    |> put_resp_header("via", "1.1 Belfrage")
    |> put_resp_header("x-bbc-no-scheme-rewrite", "1")
    |> put_resp_header("req-svc-chain", conn.private.bbc_headers.req_svc_chain)
    |> put_resp_header("cache-control", "public, max-age=60")
    |> send_resp(301, "")
    |> halt()
  end

  defp put_location(conn) do
    conn
    |> put_resp_header("location", build_location(conn))
  end

  defp build_location(conn) do
    conn
    |> normalise_path()
    |> append_query_string()
  end

  defp append_query_string(conn) do
    case conn.query_string do
      "" -> conn.request_path
      _ -> conn.request_path <> "?" <> conn.query_string
    end
  end

  defp normalise_path(conn) do
    Map.put(conn, :request_path, Path.absname(conn.request_path, ""))
  end

  defp trailing_slash?(%{request_path: path}) do
    path != "/" and String.ends_with?(path, "/")
  end
end
