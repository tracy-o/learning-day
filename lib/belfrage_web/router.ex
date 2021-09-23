defmodule BelfrageWeb.Router do
  use Plug.Router
  use Plug.ErrorHandler
  use Statix

  alias BelfrageWeb.RequestHeaders
  alias BelfrageWeb.ProductionEnvironment
  alias BelfrageWeb.PreviewMode
  alias BelfrageWeb.Plugs
  alias Belfrage.Event

  plug(Plugs.InfiniteLoopGuardian)
  plug(Plugs.RequestId)
  plug(Plugs.LatencyMonitor)
  plug(BelfrageWeb.Plugs.ResponseMetrics)
  plug(BelfrageWeb.Plugs.XRay)
  plug(Plug.Head)
  plug(BelfrageWeb.Plugs.AccessLogs)
  plug(RequestHeaders.Handler)
  plug(ProductionEnvironment)
  plug(PreviewMode)
  plug(:log_invalid_utf8)
  plug(:fetch_query_params)
  plug(BelfrageWeb.Plugs.Overrides)
  plug(Plugs.PathLogger)
  plug(:match)
  plug(:dispatch)

  get "/status" do
    send_resp(conn, 200, "I'm ok thanks")
  end

  get "/robots.txt" do
    robots_txt_path = Application.app_dir(:belfrage, "priv/static/robots.txt")

    conn
    |> put_resp_header("cache-control", "max-age=30, public")
    |> send_file(200, robots_txt_path)
  end

  options _ do
    send_resp(conn, 405, "")
  end

  match(_, to: BelfrageWeb.RoutefilePointer)

  def child_spec(scheme: scheme, port: port) do
    Plug.Cowboy.child_spec(
      scheme: scheme,
      options:
        Enum.concat(
          [
            port: port,
            protocol_options: [max_keepalive: 5_000_000, max_header_value_length: 16_384, idle_timeout: 10_000]
          ],
          options(scheme)
        ),
      plug: __MODULE__
    )
  end

  def options(:http) do
    []
  end

  def options(:https) do
    [
      certfile: Application.fetch_env!(:belfrage, :http_cert),
      keyfile: Application.fetch_env!(:belfrage, :http_cert_key),
      cacertfile: Application.fetch_env!(:belfrage, :http_cert_ca),
      otp_app: :belfrage
    ]
  end

  def handle_errors(conn, %{kind: kind, reason: reason, stack: stack}) do
    status = router_status(reason)

    Event.record(:log, :error, %{
      msg: "Router Service returned a #{status} status",
      kind: kind,
      reason: reason,
      stack: Exception.format_stacktrace(stack),
      request_path: conn.request_path,
      query_string: conn.query_string
    })

    if status == 400 do
      BelfrageWeb.View.not_found(conn)
    else
      BelfrageWeb.View.internal_server_error(conn)
    end
  end

  defp router_status(%{plug_status: plug_status}) do
    plug_status
  end

  defp router_status(_) do
    500
  end

  defp log_invalid_utf8(conn, _opts) do
    if invalid_utf8?(conn.request_path) do
      Event.record(:log, :warn, %{
        msg: "Invalid UTF8 character in request path",
        request_path: conn.request_path,
        query_string: conn.query_string
      })
    end

    if invalid_utf8?(conn.query_string) do
      Event.record(:log, :warn, %{
        msg: "Invalid UTF8 character in query string",
        request_path: conn.request_path,
        query_string: conn.query_string
      })
    end

    conn
  end

  defp invalid_utf8?(url_encoded_string) do
    try do
      !(url_encoded_string |> URI.decode() |> String.valid?())
    rescue
      ArgumentError -> false
    end
  end
end
