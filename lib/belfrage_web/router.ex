defmodule BelfrageWeb.Router do
  use Plug.Router
  use Plug.ErrorHandler
  use ExMetrics

  alias BelfrageWeb.RequestHeaders
  alias BelfrageWeb.ProductionEnvironment
  alias BelfrageWeb.PreviewMode
  alias BelfrageWeb.Plugs

  @routefile Application.get_env(:belfrage, :routefile)

  plug(Plugs.RequestId)
  plug(ExMetrics.Plug.PageMetrics)
  plug(BelfrageWeb.Plugs.XRay)
  plug(BelfrageWeb.Plugs.FormatRewriter)
  plug(Plug.Head)
  plug(BelfrageWeb.Plugs.AccessLogs)
  plug(RequestHeaders.Handler)
  plug(ProductionEnvironment)
  plug(PreviewMode)
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

  match(_, to: @routefile)

  def child_spec(scheme: scheme, port: port) do
    Plug.Cowboy.child_spec(
      scheme: scheme,
      options:
        Enum.concat(
          [
            port: port,
            protocol_options: [max_keepalive: 5_000_000, max_header_value_length: 16_384]
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

    case status do
      400 ->
        BelfrageWeb.View.not_found(conn)

      _ ->
        Belfrage.Event.record(:log, :error, %{
          msg: "Router Service returned a #{status} status",
          kind: kind,
          reason: reason,
          stack: Exception.format_stacktrace(stack)
        })

        BelfrageWeb.View.internal_server_error(conn)
    end
  end

  defp router_status(%{plug_status: plug_status}) do
    plug_status
  end

  defp router_status(_) do
    500
  end
end
