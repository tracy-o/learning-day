defmodule IngressWeb.View do
  import Plug.Conn

  alias Ingress.Struct

  @default_headers [IngressWeb.ResponseHeaders.Vary, IngressWeb.ResponseHeaders.CacheControl]

  def render_struct(struct = %Struct{response: response = %Struct.Response{}}, conn) do
    conn
    |> add_response_headers(struct)
    |> render(response.http_status, response.body)
  end

  def not_found(conn), do: error(conn, 404, "404 Not Found")

  def internal_server_error(conn), do: error(conn, 500, "500 Internal Server Error")

  def render(conn, status, content) when is_map(content) do
    conn
    |> put_resp_content_type("application/json")
    |> render(status, Poison.encode!(content))
  end

  def render(conn, status, content) when is_binary(content), do: send_resp(conn, status, content)

  defp error(conn, status, content) do
    conn
    |> put_resp_content_type("text/plain")
    |> render(status, content)
  end

  # TODO: handle unknown content type. I.e content.t != binary or map

  defp add_response_headers(conn, struct) do
    struct.response.headers
    |> Enum.reduce(conn, fn {header_key, header_value}, conn ->
      conn
      |> put_resp_header(header_key, header_value)
    end)
    |> add_default_headers(struct)
  end

  # TODO: handle default headers for 404s/500 as they not called with a struct.
  # They might need to be called with the struct

  defp add_default_headers(conn, struct) do
    Enum.reduce(@default_headers, conn, fn headers_module, output_conn ->
      apply(headers_module, :add_header, [output_conn, struct])
    end)
  end
end
