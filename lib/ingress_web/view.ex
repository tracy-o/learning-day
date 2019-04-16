defmodule IngressWeb.View do
  import Plug.Conn

  alias Ingress.Struct

  @default_headers [IngressWeb.ResponseHeaders.Vary, IngressWeb.ResponseHeaders.CacheControl]

  def render(struct = %Struct{response: response = %Struct.Response{}}, conn) do
    conn
    |> add_response_headers(struct)
    |> render(response.http_status, response.body)
  end

  def render(conn, 404) do
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(404, "404 Not Found")
  end

  def render(conn, 500) do
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(500, "500 Internal Server Error")
  end

  def add_response_headers(conn, struct) do
    struct.response.headers
    |> Enum.reduce(conn, fn {header_key, header_value}, conn ->
      conn
      |> put_resp_header(header_key, header_value)
    end)
    |> add_default_headers(struct)
  end

  def render(conn, status, content) when is_map(content) do
    conn
    |> send_resp(status, Poison.encode!(content))
  end

  def render(conn, status, content) when is_binary(content) do
    conn
    |> send_resp(status, content)
  end

  defp add_default_headers(conn, struct) do
    Enum.reduce(@default_headers, conn, fn headers_module, output_conn ->
      apply(headers_module, :add_header, [output_conn, struct])
    end)
  end
end
