defmodule BelfrageWeb.Plugs.XRay do
  @behaviour Plug
  import Plug.Conn, only: [register_before_send: 2]

  @skip_paths ["/status"]
  @xray Application.get_env(:belfrage, :xray)

  @impl true
  def init(opts), do: opts

  def build_trace_id_header(segment) do
    sampled_value = if @xray.sampled?(segment), do: '1', else: '0'

    "Root=" <> segment.trace.root <> ";Parent=" <> segment.id <> ";Sampled=#{sampled_value}"
  end

  @impl true
  def call(conn = %Plug.Conn{request_path: request_path}, _) when request_path not in @skip_paths do
    trace = @xray.new_trace()

    segment =
      trace
      |> @xray.start_tracing("Belfrage")
      |> @xray.set_http_request(%{
        method: conn.method,
        path: request_path
      })

    conn
    |> Plug.Conn.put_private(:xray_trace_id, build_trace_id_header(segment))
    |> register_before_send(&on_request_completed(&1, segment))
  end

  @impl true
  def call(conn, _opts) do
    conn
  end

  defp on_request_completed(conn, segment) do
    segment
    |> @xray.set_http_response(%{
      status: conn.status,
      content_length: content_length(conn)
    })
    |> @xray.finish_tracing()

    conn
  end

  defp content_length(conn) do
    case Plug.Conn.get_resp_header(conn, "content-length") do
      [content_length] -> content_length
      _other -> "not-reporting"
    end
  end
end
