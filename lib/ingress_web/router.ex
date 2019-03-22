defmodule IngressWeb.Router do
  use Plug.Router

  plug(Plug.Head)
  plug(:match)
  plug(:dispatch)

  alias IngressWeb.{View, WebCoreRoutes, LegacyRoutes}

  @product_allowlist ~w{_web_core news sport weather cbeebies bitesize dynasties web graphql}
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

  # get "/service-worker.js" do
  #   instance_role_name = Application.fetch_env!(:ingress, :instance_role_name)
  #   lambda_role_arn = Application.fetch_env!(:ingress, :lambda_service_worker_role)
  #   lambda = Application.fetch_env!(:ingress, :lambda_service_worker)

  #   function_payload = %{}

  #   {200, resp} = Ingress.handle(instance_role_name, lambda_role_arn, lambda, function_payload)

  #   conn
  #   |> put_resp_content_type("application/javascript")
  #   |> send_resp(200, resp["body"])
  # end

  # post "/graphql" do
  #   {:ok, body, conn} = Plug.Conn.read_body(conn)

  #   function_payload = %{
  #     body: body,
  #     httpMethod: "POST"
  #   }

  #   instance_role_name = Application.fetch_env!(:ingress, :instance_role_name)
  #   lambda_role_arn = Application.fetch_env!(:ingress, :lambda_business_role)
  #   lambda = Application.fetch_env!(:ingress, :lambda_business_layer)
  #   {200, resp} = Ingress.handle(instance_role_name, lambda_role_arn, lambda, function_payload)

  #   conn
  #   |> put_resp_content_type("application/json")
  #   |> send_resp(200, resp["body"])
  # end

  def child_spec(_arg) do
    scheme = Application.fetch_env!(:ingress, :http_scheme)

    Plug.Adapters.Cowboy.child_spec(
      scheme: scheme,
      options:
        Enum.concat(
          [
            port: Application.fetch_env!(:ingress, :http_port),
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
