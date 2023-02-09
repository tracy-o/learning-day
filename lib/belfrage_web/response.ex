defmodule BelfrageWeb.Response do
  require Logger
  import Plug.Conn

  alias Plug.Conn
  alias Belfrage.{CacheControl, Envelope, Metrics}
  alias Belfrage.Envelope.Response
  alias BelfrageWeb.Response.Headers
  alias BelfrageWeb.Response.Internal

  @default_headers [
    Headers.Vary,
    Headers.CacheControl,
    Headers.Server,
    Headers.Signature,
    Headers.BID,
    Headers.Via,
    Headers.ReqSvcChain,
    Headers.AccessControlAllowOrigin,
    Headers.RequestId,
    Headers.CacheStatus,
    Headers.RouteSpec,
    Headers.PipelineTrail
  ]
  @json_codec Application.compile_env(:belfrage, :json_codec)

  def put(conn = %Conn{assigns: %{envelope: envelope = %Envelope{response: response = %Response{}}}}) do
    response =
      if response.http_status > 399 && response.body in ["", nil] do
        Internal.new(envelope, conn)
      else
        response
      end

    envelope = %Envelope{envelope | response: response}

    conn
    |> add_response_headers(envelope)
    |> put_response(response.http_status, response.body)
  end

  def error(conn = %Conn{private: %{bbc_headers: %{cdn: true}}}, status) do
    envelope =
      conn.assigns
      |> Map.get(:envelope, %Envelope{request: %Envelope.Request{cdn?: true}})
      |> Envelope.add(:response, %{http_status: status, body: ""})

    conn
    |> assign(:envelope, envelope)
    |> put()
  end

  def error(conn = %Conn{}, status) do
    envelope =
      conn.assigns
      |> Map.get(:envelope, %Envelope{})
      |> Envelope.add(:response, %{http_status: status, body: ""})

    conn
    |> assign(:envelope, envelope)
    |> put()
  end

  def not_found(conn = %Conn{}) do
    error(conn, 404)
  end

  def internal_server_error(conn = %Conn{}) do
    error(conn, 500)
  end

  def unsupported_method(conn = %Conn{}) do
    error(conn, 405)
  end

  def redirect(conn = %Conn{}, envelope = %Envelope{}, status, new_location, ttl) do
    case :binary.match(new_location, ["\n", "\r"]) do
      {_, _} ->
        error(conn, 400)

      :nomatch ->
        conn = put_resp_header(conn, "location", new_location)

        envelope = %Envelope{
          envelope
          | response: %Response{
              http_status: status,
              cache_directive: %CacheControl{
                cacheability: "public",
                max_age: ttl,
                stale_while_revalidate: 60,
                stale_if_error: 90
              }
            }
        }

        conn
        |> assign(:envelope, envelope)
        |> put()
    end
  end

  defp put_response(conn, status, content) when is_map(content) do
    Metrics.latency_span(:return_json_response, fn ->
      conn
      |> put_resp_content_type("application/json")
      |> put_response(status, @json_codec.encode!(content))
    end)
  end

  defp put_response(conn, status, content) when is_binary(content) do
    Metrics.latency_span(:return_binary_response, fn ->
      send_resp(conn, status, content)
    end)
  end

  defp put_response(conn, _status, content) do
    :telemetry.execute([:belfrage, :error, :view, :render, :unhandled_content_type], %{})

    Logger.log(:error, "", %{
      msg: "Unhandled content type in the response. Expects a String or Map.",
      content: content
    })

    internal_server_error(conn)
  end

  defp add_response_headers(conn, envelope) do
    Metrics.latency_span(:set_response_headers, fn ->
      envelope.response.headers
      |> Enum.reduce(conn, fn
        {header_key, header_value}, conn when is_binary(header_value) ->
          put_resp_header(conn, header_key, header_value)

        {header_key, invalid_header_value}, conn ->
          Logger.log(:warn, "", %{
            msg: "Not adding non-string header value to response",
            header_key: header_key,
            header_value: invalid_header_value
          })

          conn
      end)
      |> add_default_headers(envelope)
    end)
  end

  defp add_default_headers(conn, envelope) do
    Enum.reduce(@default_headers, conn, fn headers_module, output_conn ->
      apply(headers_module, :add_header, [output_conn, envelope])
    end)
  end
end
