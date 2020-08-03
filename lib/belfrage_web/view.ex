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
    ResponseHeaders.BID,
    ResponseHeaders.Via,
    ResponseHeaders.ReqSvcChain,
    ResponseHeaders.AccessControlAllowOrigin
  ]
  @json_codec Application.get_env(:belfrage, :json_codec)

  def render(%Struct{response: %Struct.Response{http_status: status, headers: %{"content-length" => "0"}}}, conn) when status > 399 do
    internal_response(conn, status)
  end

  def render(struct = %Struct{response: response = %Struct.Response{}}, conn) do
    conn
    |> add_response_headers(struct)
    |> put_response(response.http_status, response.body)
  end

  def not_found(conn), do: internal_response(conn, 404)
  def internal_server_error(conn), do: internal_response(conn, 500)
  def unsupported_method(conn), do: internal_response(conn, 405)

  def redirect(struct, conn, status, new_location) do
    conn
    |> put_resp_header("location", new_location)
    |> redirect_response(status, struct)
  end

  defp put_response(conn, status, content) when is_map(content) do
    conn
    |> put_resp_content_type("application/json")
    |> put_response(status, @json_codec.encode!(content))
  end

  defp put_response(conn, status, content) when is_binary(content),
    do: send_resp(conn, status, content)

  defp put_response(conn, _status, content) do
    Belfrage.Event.record(:metric, :increment, "error.view.render.unhandled_content_type")

    Stump.log(:error, %{
      msg: "Unhandled content type in the response. Expects a String or Map.",
      content: content
    })

    internal_server_error(conn)
  end

  defp internal_response(conn, status) do
    render(
      %Struct{response: BelfrageWeb.View.InternalResponse.new(conn, status)},
      conn
    )
  end

  defp redirect_response(conn, status, struct) do
    response = BelfrageWeb.View.InternalResponse.new(conn, status)
    render(Belfrage.Struct.add(struct, :response, response), conn)
  end

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

  defp add_default_headers(conn, struct) do
    Enum.reduce(@default_headers, conn, fn headers_module, output_conn ->
      apply(headers_module, :add_header, [output_conn, struct])
    end)
  end
end
