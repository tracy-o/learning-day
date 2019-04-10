defmodule IngressWeb.Router do
  use Plug.Router
  use ExMetrics

  plug(ExMetrics.Plug.PageMetrics)
  plug(Plug.Head)
  plug(:match)
  plug(:dispatch)

  alias IngressWeb.{View, WebCoreRoutes, LegacyRoutes}

  # TODO: convince me we need an allowlist here
  @product_allowlist ~w{_web_core news sport weather cbeebies bitesize dynasties web graphql service-worker.js}
  @allowed_http_methods [:head, :get, :post]

  get "/status" do
    conn
    |> View.render(200, "I'm ok thanks")
  end

  match("/:product/*_rest" when product in @product_allowlist,
    via: @allowed_http_methods,
    to: WebCoreRoutes
  )

  match(_, via: @allowed_http_methods, to: LegacyRoutes)

  def child_spec([scheme: scheme, port: port]) do

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
end
