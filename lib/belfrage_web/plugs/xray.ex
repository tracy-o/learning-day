defmodule BelfrageWeb.Plugs.Xray do
  @behaviour Plug
  require Logger
  import Plug.Conn, only: [register_before_send: 2, assign: 3, get_req_header: 2]
  alias Belfrage.Xray

  @skip_paths ["/status"]

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn = %Plug.Conn{request_path: request_path}, opts) when request_path not in @skip_paths do
    xray = Keyword.get(opts, :xray, Xray)
    segment = build_segment(conn, "Belfrage", xray)

    conn
    |> assign(:xray_segment, segment)
    |> register_before_send(&on_request_completed(&1, segment, xray))
  end

  def call(conn, _opts), do: conn

  defp build_segment(conn, name, xray) do
    segment =
      case get_req_header(conn, "x-amzn-trace-id") do
        [trace_header] -> try_parse_header(name, trace_header, xray)
        _ -> xray.start_tracing(name)
      end

    segment
    |> xray.add_annotations(%{request_id: conn.private.request_id})
    |> xray.add_metadata(%{xray: xray})
    |> xray.set_http_request(%{method: conn.method, path: conn.request_path})
  end

  defp try_parse_header(name, trace_header, xray) do
    case xray.parse_header(name, trace_header) do
      {:ok, segment} ->
        segment

      {:error, :invalid} ->
        Logger.log(
          :error,
          "failed to create segment with 'x-amzn-trace-id' header: #{trace_header}"
        )

        xray.start_tracing(name)
    end
  end

  defp on_request_completed(conn, segment, xray) do
    segment =
      segment
      |> xray.finish()
      |> xray.set_http_response(%{
        status: conn.status,
        content_length: content_length(conn)
      })

    xray.send(segment)

    conn
    |> assign(:xray_segment, segment)
  end

  defp content_length(conn) do
    case Plug.Conn.get_resp_header(conn, "content-length") do
      [content_length] -> content_length
      _other -> 0
    end
  end
end
