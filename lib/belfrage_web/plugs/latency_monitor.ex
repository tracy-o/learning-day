defmodule BelfrageWeb.Plugs.LatencyMonitor do
  @behaviour Plug
  import Plug.Conn, only: [put_private: 3, register_before_send: 2]
  import Belfrage.Metrics.LatencyMonitor, only: [checkpoint: 2]

  @spec init(any) :: any
  def init(opts), do: opts

  def call(conn, _opts) do
    checkpoint(conn.private.request_id, :request_start)

    register_before_send(conn, fn
      conn = %Plug.Conn{status: 200} ->
        checkpoint(conn.private.request_id, :response_end)
        conn

      conn ->
        conn
    end)
  end
end
