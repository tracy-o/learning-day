defmodule BelfrageWeb.Plugs.LatencyMonitor do
  alias Belfrage.Metrics.LatencyMonitor

  @behaviour Plug
  import Plug.Conn, only: [register_before_send: 2]

  def init(opts), do: opts

  def call(conn, _opts) do
    conn =
      conn
      |> Plug.Conn.assign(:request_received, get_time())

    register_before_send(conn, fn
      conn = %Plug.Conn{status: status} when status in [200, :ok] ->
        conn.assigns[:struct]
        |> case do
          nil -> nil

          struct ->
            LatencyMonitor.checkpoint(struct, :response_sent)
        end

        conn

      conn ->
        conn
    end)
  end

  defp get_time(), do: System.monotonic_time(:nanosecond) / 1_000_000
end
