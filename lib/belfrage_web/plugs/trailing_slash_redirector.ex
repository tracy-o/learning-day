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
    |> send_resp(301, "Redirecting")
    |> halt()
  end

  defp put_location(conn) do
    conn
    |> put_resp_header("location", remove_trailing(conn.request_path))
  end

  defp remove_trailing(location) do
    case String.replace_trailing(location, "/", "") do
      "" -> "/"
      location -> location
    end
  end

  defp trailing_slash?(%{request_path: path}) do
    path != "/" and String.ends_with?(path, "/")
  end
end
