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
      req_headers: Belfrage.PII.clean(conn.req_headers),
      resp_headers: Belfrage.PII.clean(conn.resp_headers)
    })

    conn
  end
end
