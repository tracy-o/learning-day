defmodule Ingress do
  use Plug.Router

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
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, "hello from the root")
  end

  get "/:service" when service in(@services) do
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, "hello #{service}")
  end

  match _ do
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(404, "Not Found")
  end
end
