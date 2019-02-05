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
    {:ok, resp} = Ingress.handle("homepage")

    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, resp.body)
  end

  get "/:service" when service in(@services) do
    {:ok, resp} = Ingress.handle(service)

    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, resp.body)
  end

  post "/graphql" do
    {:ok, body, conn} = Plug.Conn.read_body(conn)
    {:ok, resp} = Ingress.handle("graphql", body)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, resp.body)
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
