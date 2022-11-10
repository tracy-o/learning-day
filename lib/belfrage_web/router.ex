defmodule BelfrageWeb.Router do
  require Logger
  use Plug.Router
  use Plug.ErrorHandler

  alias BelfrageWeb.RequestHeaders
  alias BelfrageWeb.ProductionEnvironment
  alias BelfrageWeb.PreviewMode
  alias BelfrageWeb.Plugs

  plug(Plug.Telemetry, event_prefix: [:belfrage, :plug])
  plug(Plugs.InfiniteLoopGuardian)
  plug(Plugs.RequestId)
  plug(Plugs.LatencyMonitor)
  plug(BelfrageWeb.Plugs.Xray, builder_opts())
  plug(Plug.Head)
  plug(BelfrageWeb.Plugs.AccessLogs)
  plug(RequestHeaders.Handler)
  plug(ProductionEnvironment)
  plug(Plugs.HttpRedirector)
  plug(Plugs.TrailingSlashRedirector)
  plug(PreviewMode)
  plug(:log_invalid_utf8)
  plug(:fetch_query_params, validate_utf8: false)
  plug(BelfrageWeb.Plugs.Overrides)
  plug(Plugs.PathLogger)
  plug(:match)
  plug(:dispatch)

  def call(conn, opts) do
    conn
    |> assign(:plug_pipeline_start_time, System.monotonic_time())
    |> assign(:routefile, opts[:routefile])
    |> super(opts)
  end

  def dispatch(conn, opts) do
    Belfrage.Metrics.latency_stop(:plug_pipeline, conn.assigns.plug_pipeline_start_time)
    super(conn, opts)
  end

  get "/status" do
    send_resp(conn, 200, "I'm ok thanks")
  end

  get "/robots.txt" do
    robots_txt_path = Application.app_dir(:belfrage, "priv/static/robots.txt")

    conn
    |> put_resp_header("cache-control", "max-age=30, public")
    |> send_file(200, robots_txt_path)
  end

  options "/news/breaking-news/audience/:audience" when audience in ~w(domestic us international asia) do
    conn
    |> put_resp_header("access-control-allow-methods", "GET, OPTIONS")
    |> put_resp_header("access-control-allow-origin", "*")
    |> put_resp_header("cache-control", "max-age=60, public")
    |> send_resp(204, "")
  end

  options "/wc-data/*any" do
    conn
    |> put_resp_header("access-control-allow-methods", "GET, OPTIONS")
    |> put_resp_header("access-control-allow-origin", "*")
    |> put_resp_header("cache-control", "max-age=60, public")
    |> send_resp(204, "")
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

    Logger.error("", %{
      msg: "Router Service returned a #{status} status",
      kind: kind,
      reason: inspect(reason),
      stack: Exception.format_stacktrace(stack),
      request_path: conn.request_path,
      query_string: conn.query_string
    })

    if status == 400 do
      BelfrageWeb.Response.not_found(conn)
    else
      BelfrageWeb.Response.internal_server_error(conn)
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
      Logger.log(:warn, "", %{
        msg: "Invalid UTF8 character in request path",
        request_path: conn.request_path,
        query_string: conn.query_string
      })
    end

    if invalid_utf8?(conn.query_string) do
      Logger.log(:warn, "", %{
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
