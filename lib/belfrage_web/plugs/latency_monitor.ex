defmodule BelfrageWeb.Plugs.LatencyMonitor do
  @behaviour Plug
  import Plug.Conn, only: [register_before_send: 2]
  import Belfrage.Metrics.LatencyMonitor, only: [checkpoint: 2, discard: 1]

  def init(opts), do: opts

  def call(conn, _opts) do
    request_id = conn.private.request_id
    checkpoint(request_id, :request_start)

    register_before_send(conn, fn
      conn = %Plug.Conn{status: status} when status in [200, :ok] ->
        checkpoint(request_id, :response_end)
        conn

      conn ->
        discard(request_id)
        conn
    end)
  end
end
