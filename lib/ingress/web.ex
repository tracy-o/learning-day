defmodule Ingress.Web do
  use Plug.Router

  plug Plug.Head
  plug :match
  plug :dispatch

  @services ["news", "sport", "weather", "bitesize", "cbeebies", "dynasties"]

  get "/status" do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "ok!")
  end

  get "/" do
    ec2_role = Application.fetch_env!(:ingress, :ec2_role)
    lambda_role = Application.fetch_env!(:ingress, :lambda_presentation_role)
    lambda = Application.fetch_env!(:ingress, :lambda_presentation_layer)

    function_payload = %{
      path: conn.request_path
    }

    {200, resp} = Ingress.handle(ec2_role, lambda_role, lambda, function_payload)

    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, resp["body"])
  end

  get "/:service" when service in(@services) do
    ec2_role = Application.fetch_env!(:ingress, :ec2_role)
    lambda_role = Application.fetch_env!(:ingress, :lambda_presentation_role)
    lambda = Application.fetch_env!(:ingress, :lambda_presentation_layer)

    function_payload = %{
      path: conn.request_path
    }

    {200, resp} = Ingress.handle(ec2_role, lambda_role, lambda, function_payload)

    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, resp["body"])
  end

  post "/graphql" do
    {:ok, body, conn} = Plug.Conn.read_body(conn)

    function_payload = %{
      body: body,
      httpMethod: "POST"
    }

    ec2_role = Application.fetch_env!(:ingress, :ec2_role)
    lambda_role = Application.fetch_env!(:ingress, :lambda_business_role)
    lambda = Application.fetch_env!(:ingress, :lambda_business_layer)
    {200, resp} = Ingress.handle(ec2_role, lambda_role, lambda, function_payload)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, resp["body"])
  end

  match _ do
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(404, "Not Found")
  end

  def child_spec(_arg) do
    Plug.Adapters.Cowboy.child_spec(
      scheme: :http,
      options: [port: Application.fetch_env!(:ingress, :http_port), protocol_options: [max_keepalive: 5_000_000]],
      plug: __MODULE__
    )
  end
end
