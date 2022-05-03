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
    segment = parse_or_new_trace(conn, name, xray)

    segment
    |> xray.add_annotations(%{request_id: conn.private.request_id})
    |> xray.add_metadata(%{xray: xray})
    |> xray.set_http_request(%{method: conn.method, path: conn.request_path})
  end

  defp parse_or_new_trace(conn, name, xray) do
    trace_header = req_header(conn, "x-amzn-trace-id")
    req_svc_chain = req_header(conn, "req-svc-chain")

    cond do
      is_nil(trace_header) ->
        xray.start_tracing(name)

      from_belfrage(req_svc_chain) or local_request(req_svc_chain) ->
        parse_header(name, trace_header, xray)

      partial_trace_header?(trace_header) and String.length(trace_header) < 200 ->
        parse_header(name, trace_header, xray)

      true ->
        xray.start_tracing(name)
    end
  end

  defp parse_header(name, trace_header, xray) do
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

  defp partial_trace_header?(trace_header) do
    trace_map = trace_header_as_map(trace_header)
    Map.has_key?(trace_map, "Root") and not Map.has_key?(trace_map, "Sampled")
  end

  defp local_request(req_svc_chain) do
    is_nil(req_svc_chain)
  end

  defp from_belfrage(req_svc_chain) do
    if req_svc_chain do
      split_chain = String.split(req_svc_chain, ",")
      "BELFRAGE" in split_chain
    else
      false
    end
  end

  defp req_header(conn, key), do: get_req_header(conn, key) |> parse_req_header()

  defp parse_req_header([header]), do: header
  defp parse_req_header(_), do: nil

  defp trace_header_as_map(trace_header) do
    if trace_header do
      trace_header
      |> String.split(";")
      |> Enum.map(fn pair -> String.split(pair, "=") end)
      |> Map.new(fn [k, v] -> {k, v} end)
    else
      %{}
    end
  end

  defp content_length(conn) do
    case Plug.Conn.get_resp_header(conn, "content-length") do
      [content_length] -> content_length
      _other -> 0
    end
  end
end
