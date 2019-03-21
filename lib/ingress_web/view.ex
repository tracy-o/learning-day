defmodule IngressWeb.View do
  import Plug.Conn

  alias Ingress.Struct

  def render(struct = %Struct{}, conn) do
    IO.inspect("render with struct called")

    conn
    |> render(struct.response.http_status, struct.response.body)
  end

  def render(conn, 404) do
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(404, "Not Found")
  end

  def render(conn, status, content) when is_map(content) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Poison.encode!(content))
  end

  def render(conn, status, content) when is_binary(content) do
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(status, content)
  end
end
