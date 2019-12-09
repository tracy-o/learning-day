defmodule BelfrageWeb.Plugs.XRay do
  @behaviour Plug
  import Plug.Conn, only: [register_before_send: 2]

  @skip_paths ["/status"]
  @xray Application.get_env(:belfrage, :xray)

  def init(opts), do: opts

  def build_trace_id_header(root, parent) do
    "Root=" <> root <> ";Parent=" <> parent 
   end

  @impl true
  def call(conn = %Plug.Conn{request_path: request_path}, _) when request_path not in @skip_paths do
    trace = @xray.new_trace()
    segment = @xray.start_tracing(trace, "Belfrage")

    conn
    |> Plug.Conn.put_private(:xray_trace_id, build_trace_id_header(segment.trace.root, segment.id))
    |> register_before_send(&on_request_completed(&1, segment))
  end

  defp on_request_completed(conn, segment) do
    @xray.finish_tracing(segment)
    conn
  end

  @impl true
  def call(conn, _opts) do
    conn
  end
end