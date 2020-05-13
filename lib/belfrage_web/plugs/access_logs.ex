defmodule BelfrageWeb.Plugs.AccessLogs do
  import Plug.Conn, only: [register_before_send: 2]
  alias BelfrageWeb.RequestHeaders.Mapper

  def init(opts), do: opts

  def call(conn, _opts) do
    register_before_send(conn, &write_access_log/1)
  end

  defp write_access_log(conn) do
    Stump.log(:debug, %{
      path: conn.request_path,
      status: conn.status,
      method: conn.method,
      req_headers: clear_cookies(conn.req_headers),
      resp_headers: clear_cookies(conn.resp_headers)
    })

    conn
  end

  defp clear_cookies(headers) do
    headers |> Enum.map(fn {key, value} ->
      case String.contains?(key, "cookie") do
        true -> {key, "REDACTED"}
        false -> {key, value}
      end
    end)
  end
end
