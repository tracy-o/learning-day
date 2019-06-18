defmodule IngressWeb.Router do
  use Plug.Router
  use Plug.ErrorHandler
  use ExMetrics

  alias IngressWeb.RequestHeaders

  plug(ExMetrics.Plug.PageMetrics)
  plug(Plug.Head)
  plug(RequestHeaders.Handler)
  plug(:match)
  plug(:dispatch)

  alias IngressWeb.{View, WebCoreRoutes, LegacyRoutes}

  # TODO: convince me we need an allowlist here
  @product_allowlist ~w{_web_core news sport weather cbeebies bitesize dynasties web bbcthree topics graphql service-worker.js}
  @allowed_http_methods [:head, :get, :post]

  # TODO: perhaps create a struct/have a loop generation and serve this 200 by going all the way through the app
  # this would give us more confidence in /status but could be overkill in effort
  # it would also mean put_response could become private to the view and be renamed to render
  get "/status" do
    conn
    |> View.put_response(200, "I'm ok thanks")
  end

  match("/", via: @allowed_http_methods, to: WebCoreRoutes)

  match("/:product/*_rest" when product in @product_allowlist,
    via: @allowed_http_methods,
    to: WebCoreRoutes
  )

  match(_, via: @allowed_http_methods, to: LegacyRoutes)

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
      certfile: Application.fetch_env!(:ingress, :http_cert),
      keyfile: Application.fetch_env!(:ingress, :http_cert_key),
      cacertfile: Application.fetch_env!(:ingress, :http_cert_ca),
      otp_app: :ingress
    ]
  end

  def handle_errors(conn, %{kind: kind, reason: reason, stack: stack}) do
    Stump.log(:error, %{
      msg: "Router Service returned a 500 status",
      kind: kind,
      reason: reason,
      stack: Exception.format_stacktrace(stack)
    })

    View.internal_server_error(conn)
  end
end
