defmodule IngressWeb.View do
  import Plug.Conn

  alias Ingress.Struct

  def render(struct = %Struct{response: response = %Struct.Response{}}, conn) do

    conn
    |> add_response_headers(struct)
    |> render(struct.response.http_status, struct.response.body)
  end

  def render(conn, 404) do
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(404, "Not Found")
  end

  def add_response_headers(conn, struct) do
    struct.response.headers
    |> Enum.reduce(conn, fn {header_key, header_value}, conn ->
      conn
      |> put_resp_header(header_key, header_value)
    end)
  end

  def render(conn, status, content) when is_map(content) do
    conn
    |> send_resp(status, Poison.encode!(content))
  end

  def render(conn, status, content) when is_binary(content) do
    conn
    |> send_resp(status, content)
  end
end
