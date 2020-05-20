defmodule BelfrageWeb.Plugs.AccessLogs do
  import Plug.Conn, only: [register_before_send: 2]
  alias BelfrageWeb.RequestHeaders.Mapper

  def init(opts), do: opts

  def call(conn, _opts) do
    register_before_send(conn, &write_access_log/1)
  end

  defp write_access_log(conn) do
    Stump.log(:info, %{
      path: conn.request_path,
      status: conn.status,
      method: conn.method,
      req_headers: clear_cookies(conn.req_headers),
      resp_headers: clear_cookies(conn.resp_headers)
    })

    conn
  end

  defp clear_cookies(headers, acc \\ [])
  defp clear_cookies([], acc), do: acc
  defp clear_cookies([header | rest], acc) do
    clear_cookies(rest, [maybe_redact(header) | acc])
  end

  defp maybe_redact({key, value}) do
    case String.contains?(key, ["cookie", "ssl"]) do
      true -> {key, "REDACTED"}
      false -> {key, value}
    end
  end
end
