defmodule BelfrageWeb.Plugs.XRay do
  @behaviour Plug
  import Plug.Conn, only: [register_before_send: 2]

  @skip_paths ["/status"]
  @xray Application.get_env(:belfrage, :xray)

  def init(opts), do: opts

  @impl true
  def call(conn = %Plug.Conn{request_path: request_path}, _) when request_path not in @skip_paths do
    trace = @xray.new_trace()
    segment = @xray.start_tracing(trace, "Belfrage")

    conn
    |> Plug.Conn.put_private(:xray_trace_id, segment.trace.root)
    |> register_before_send(fn conn ->
      @xray.finish_tracing(segment)
      conn
    end)
  end

  @impl true
  def call(conn, _opts) do
    conn
  end
end