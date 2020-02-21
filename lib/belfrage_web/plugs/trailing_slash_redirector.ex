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
    |> send_resp(301, "Redirecting")
    |> halt()
  end

  defp put_location(conn) do
    conn
    |> put_resp_header("location", build_uri(conn))
  end

  defp build_uri(conn) do
    conn
    |> Map.replace!(:request_path, String.replace_trailing(conn.request_path, "/", ""))
    |> request_url()
  end

  defp trailing_slash?(%{ request_path: path }) do
    path != "/" and String.ends_with?(path, "/")
  end
end
