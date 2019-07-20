defmodule BelfrageWeb.Router do
  use Plug.Router
  use Plug.ErrorHandler
  use ExMetrics

  alias BelfrageWeb.RequestHeaders

  plug(ExMetrics.Plug.PageMetrics)
  plug(Plug.Head)
  plug(RequestHeaders.Handler)
  plug(:match)
  plug(:dispatch)

  get "/status" do
    send_resp(conn, 200, "I'm ok thanks")
  end

  match(_, to: Routes.Routefile)

  def child_spec(scheme: scheme, port: port) do
    Plug.Adapters.Cowboy.child_spec(
      scheme: scheme,
      options:
        Enum.concat(
          [
            port: port,
            protocol_options: [max_keepalive: 5_000_000]
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
    Stump.log(:error, %{
      msg: "Router Service returned a 500 status",
      kind: kind,
      reason: reason,
      stack: Exception.format_stacktrace(stack)
    })

    BelfrageWeb.View.internal_server_error(conn)
  end
end
