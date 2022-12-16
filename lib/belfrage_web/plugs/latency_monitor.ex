defmodule BelfrageWeb.Plugs.LatencyMonitor do
  alias Belfrage.Metrics.LatencyMonitor
  alias Belfrage.Metrics

  @behaviour Plug
  import Plug.Conn, only: [register_before_send: 2]

  def init(opts), do: opts

  def call(conn, _opts) do
    conn =
      conn
      |> Plug.Conn.assign(:request_received, get_time())

    register_before_send(conn, &on_request_completed/1)
  end

  defp on_request_completed(conn = %Plug.Conn{status: status}) when status in [200, :ok] do
    Metrics.latency_span(:register_before_send_latency_monitor, fn ->
      conn.assigns[:struct]
      |> case do
        nil ->
          nil

        struct ->
          LatencyMonitor.checkpoint(struct, :response_sent)
      end

      conn
    end)
  end

  defp on_request_completed(conn), do: conn

  defp get_time(), do: System.monotonic_time(:nanosecond) / 1_000_000
end
