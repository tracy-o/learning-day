defmodule IngressWeb.View do
  import Plug.Conn

  alias Ingress.Struct

  @default_headers [IngressWeb.ResponseHeaders.Vary, IngressWeb.ResponseHeaders.CacheControl]

  def render(struct = %Struct{response: response = %Struct.Response{}}, conn) do
    conn
    |> add_response_headers(struct)
    |> put_response(response.http_status, response.body)
  end

  def not_found(conn), do: error(conn, 404, "404 Not Found")

  def internal_server_error(conn), do: error(conn, 500, "500 Internal Server Error")

  def put_response(conn, status, content) when is_map(content) do
    conn
    |> put_resp_content_type("application/json")
    |> put_response(status, Poison.encode!(content))
  end

  def put_response(conn, status, content) when is_binary(content),
    do: send_resp(conn, status, content)

  def put_response(conn, _, content) do
    ExMetrics.increment("error.view.render.unhandled_content_type")

    Stump.log(:error, %{
      msg: "Unhandled content type in the response. Expects a String or Map.",
      content: content
    })

    internal_server_error(conn)
  end

  # TODO: Should we set the content type to be relating to the original request, as per this discussion: https://github.com/bbc/ingress/pull/41#discussion_r281946726
  defp error(conn, status, content) do
    conn
    |> add_default_headers(%Struct{response: %Struct.Response{http_status: status}})
    |> put_resp_content_type("text/plain")
    |> put_response(status, content)
  end

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
