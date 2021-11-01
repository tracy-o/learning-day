defmodule BelfrageWeb.Plugs.ResponseMetrics do
  @behaviour Plug
  import Plug.Conn, only: [register_before_send: 2, get_resp_header: 2]
  alias Belfrage.{Metrics.Statix, Event}

  def init(opts), do: opts

  def call(conn, _opts) do
    before_time = System.monotonic_time(:millisecond)
    Statix.increment("web.request.count", 1, tags: Event.global_dimensions())

    register_before_send(conn, fn conn ->
      timing = (System.monotonic_time(:millisecond) - before_time) |> abs

      Statix.increment("web.response.status.#{conn.status}", 1, tags: Event.global_dimensions())
      Statix.timing("web.response.timing.#{conn.status}", timing, tags: Event.global_dimensions())
      Statix.timing("web.response.timing.page", timing, tags: Event.global_dimensions())

      if conn.status == 200 and private_response?(conn) do
        Statix.increment("web.response.private", 1, tags: Event.global_dimensions())
      end

      conn
    end)
  end

  def private_response?(conn) do
    header =
      conn
      |> get_resp_header("cache-control")
      |> List.first()

    header && String.contains?(header, "private")
  end
end
