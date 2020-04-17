defmodule BelfrageWeb.View do
  import Plug.Conn

  alias Belfrage.Struct
  alias BelfrageWeb.ResponseHeaders

  @default_headers [
    ResponseHeaders.Vary,
    ResponseHeaders.CacheControl,
    ResponseHeaders.Server,
    ResponseHeaders.Signature,
    ResponseHeaders.Fallback,
    ResponseHeaders.BID
  ]
  @json_codec Application.get_env(:belfrage, :json_codec)
  @file_io Application.get_env(:belfrage, :file_io)

  def render(struct = %Struct{response: response = %Struct.Response{}}, conn) do
    conn
    |> add_response_headers(struct)
    |> put_response(response.http_status, response.body)
  end

  def not_found(conn), do: error(conn, 404, error_page(404))
  def internal_server_error(conn), do: error(conn, 500, error_page(500))

  def put_response(conn, status, content) when is_map(content) do
    conn
    |> put_resp_content_type("application/json")
    |> put_response(status, @json_codec.encode!(content))
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

  # TODO: Should we set the content type to be relating to the original request, as per this discussion: https://github.com/bbc/belfrage/pull/41#discussion_r281946726
  defp error(conn, status, content) do
    conn
    |> add_default_headers(%Struct{response: %Struct.Response{http_status: status}})
    |> put_resp_content_type("text/html")
    |> put_response(status, content)
  end

  defp error_page(404), do: error_page(Application.get_env(:belfrage, :not_found_page), 404)
  defp error_page(500), do: error_page(Application.get_env(:belfrage, :internal_error_page), 500)

  defp error_page(path, status) do
    case @file_io.read(path) do
      {:ok, body} -> body <> "<!-- Belfrage -->"
      {:error, _} -> default_error_body(status)
    end
  end

  defp default_error_body(500), do: "<h1>500 Internal Server Error</h1>\n<!-- Belfrage -->"
  defp default_error_body(404), do: "<h1>404 Page Not Found</h1>\n<!-- Belfrage -->"

  defp add_response_headers(conn, struct) do
    struct.response.headers
    |> Enum.reduce(conn, fn
      {header_key, header_value}, conn when is_binary(header_value) ->
        put_resp_header(conn, header_key, header_value)

      {header_key, invalid_header_value}, conn ->
        Stump.log(:warn, %{
          msg: "Not adding non-string header value to response",
          header_key: header_key,
          header_value: invalid_header_value
        })

        conn
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
