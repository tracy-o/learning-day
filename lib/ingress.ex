defmodule Ingress do
  use Plug.Router

  alias Ingress.Handler

  plug Plug.Head
  plug :match
  plug :dispatch

  @services ["news", "sport", "weather", "bytesize", "cbeebies", "dynasties"]

  get "/status" do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "ok!")
  end

  get "/" do
    {:ok, resp} = Handler.handle("homepage")

    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, resp.body)
  end

  get "/:service" when service in(@services) do
    {:ok, resp} = Handler.handle(service)

    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, resp.body)
  end

  match _ do
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(404, "Not Found")
  end
end
