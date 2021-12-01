defmodule BelfrageWeb.Plugs.Xray do
  @behaviour Plug
  import Plug.Conn, only: [register_before_send: 2, assign: 3]
  alias Belfrage.Xray


  @skip_paths ["/status"]


  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn = %Plug.Conn{request_path: request_path}, opts) when request_path not in @skip_paths do
    xray = Keyword.get(opts, :xray_client, Xray)

    segment =
      xray.start_tracing("Belfrage")
      |> xray.add_annotations(%{request_id: conn.private.request_id})
      |> xray.add_metadata(%{xray_client: xray})
      |> xray.set_http_request(%{method: conn.method, path: request_path})

    conn
    |> assign(:xray_segment, segment)
    |> register_before_send(&on_request_completed(&1, segment, xray))
  end

  def call(conn, _opts), do: conn

  defp on_request_completed(conn, segment, xray) do
    segment =
      segment
      |> xray.finish()
      |> xray.set_http_response(%{
        status: conn.status, content_length: content_length(conn)
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
