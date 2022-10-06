defmodule BelfrageWeb.Plugs.TrailingSlashRedirector do
  import Plug.Conn

  @moduledoc """
  Redirects a request with
  a request path and a trailing slash
  to one without a trailing slash.
  NOTE : This doesn't take into account query strings
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
    |> put_resp_header("vary", "Accept-Encoding,X-BBC-Edge-Cache,X-Country,X-IP_Is_UK_Combined,X-BBC-Edge-Scheme")
    |> put_resp_header("req-svc-chain", "GTM,BELFRAGE")
    |> put_resp_header("cache-control", "public, stale-if-error=90, stale-while-revalidate=30, max-age=60")
    |> send_resp(301, "")
    |> halt()
  end

  defp put_location(conn) do
    conn
    |> put_resp_header("location", build_location(conn))
  end

  defp build_location(conn) do
    conn
    |> remove_trailing()
    |> append_query_string()
  end

  defp append_query_string(conn) do
    case conn.query_string do
      "" -> conn.request_path
      _ -> conn.request_path <> "?" <> conn.query_string
    end
  end

  defp remove_trailing(conn) do
    case String.replace_trailing(conn.request_path, "/", "") do
      "" -> Map.put(conn, :request_path, "/")
      location -> Map.put(conn, :request_path, location)
    end
  end

  defp trailing_slash?(%{request_path: path}) do
    path != "/" and String.ends_with?(path, "/")
  end
end
