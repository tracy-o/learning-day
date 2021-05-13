defmodule BelfrageWeb.Plugs.ResponseMetrics do
  @behaviour Plug
  import Plug.Conn, only: [register_before_send: 2]

  def init(opts), do: opts

  def call(conn, _opts) do
    before_time = System.monotonic_time(:millisecond)
    Belfrage.Metrics.Statix.increment("web.request.count")

    register_before_send(conn, fn conn ->
      timing = (System.monotonic_time(:millisecond) - before_time) |> abs

      Belfrage.Metrics.Statix.increment("web.response.status.#{conn.status}")
      Belfrage.Metrics.Statix.timing("web.response.timing.#{conn.status}", timing)
      Belfrage.Metrics.Statix.timing("web.response.timing.page", timing)
      conn
    end)
  end
end