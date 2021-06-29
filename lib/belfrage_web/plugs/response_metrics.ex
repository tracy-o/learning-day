defmodule BelfrageWeb.Plugs.ResponseMetrics do
  @behaviour Plug
  import Plug.Conn, only: [register_before_send: 2, get_resp_header: 2]

  def init(opts), do: opts

  def call(conn, _opts) do
    before_time = System.monotonic_time(:millisecond)
    Belfrage.Metrics.Statix.increment("web.request.count")

    register_before_send(conn, fn conn ->
      timing = (System.monotonic_time(:millisecond) - before_time) |> abs

      Belfrage.Metrics.Statix.increment("web.response.status.#{conn.status}")
      Belfrage.Metrics.Statix.timing("web.response.timing.#{conn.status}", timing)
      Belfrage.Metrics.Statix.timing("web.response.timing.page", timing)

      if conn.status == 200 and String.contains?(cache_control_header(conn), "private") do
        Belfrage.Metrics.Statix.increment("web.response.private")
      end

      conn
    end)
  end

  def cache_control_header(conn) do
    List.first(get_resp_header(conn, "cache-control"))
  end
end
