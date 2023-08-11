defmodule Belfrage.Services.Dispatcher do
  require Logger

  alias Belfrage.Clients
  alias Belfrage.Envelope
  alias Belfrage.Envelope.{Private, Response}
  alias Belfrage.Helpers.QueryParams
  alias Belfrage.Metrics.LatencyMonitor

  def dispatch(envelope = %Envelope{private: private = %Private{}}, headers) do
    built_request = build_request(envelope, headers)
    envelope = LatencyMonitor.checkpoint(envelope, :origin_request_sent)
    result = built_request |> execute_request(private)
    envelope = LatencyMonitor.checkpoint(envelope, :origin_response_received)

    response =
      case result do
        {:ok, response} ->
          track_response(private, response.status_code)
          %Response{http_status: response.status_code, body: response.body, headers: response.headers}

        {:error, %Clients.HTTP.Error{reason: :invalid_request_target}} ->
          %Response{http_status: 404, body: ""}

        {:error, %Clients.HTTP.Error{reason: :invalid_header_value}} ->
          %Response{http_status: 400, body: ""}

        {:error, error} ->
          track_error(envelope, error)
          %Response{http_status: 500, body: ""}
      end

    %Envelope{envelope | response: response}
  end

  defp build_request(%Envelope{request: request, private: private}, headers) do
    attrs =
      case request.method do
        "GET" ->
          %{method: :get}

        method ->
          raise "Unsupported method: " <> method
      end

    struct!(
      Clients.HTTP.Request,
      Map.merge(attrs, %{
        url: private.origin <> request.path <> QueryParams.encode(request.query_params),
        headers: headers,
        request_id: request.request_id
      })
    )
  end

  defp execute_request(request = %Clients.HTTP.Request{}, private = %Private{}) do
    platform = platform_name(private)

    :telemetry.span([:belfrage, :function, :timing, :service, platform, :request], %{}, fn ->
      {http_impl().execute(request, platform), %{}}
    end)
  end

  defp http_impl() do
    Application.get_env(:belfrage, :http_client, Belfrage.Clients.HTTP)
  end

  defp track_response(private = %Private{}, status) do
    Belfrage.Metrics.multi_execute(
      [
        [:belfrage, :service, platform_name(private), :response, String.to_atom(to_string(status))],
        [:belfrage, :platform, :response]
      ],
      %{count: 1},
      %{platform: platform_name(private), status_code: status}
    )
  end

  defp track_error(envelope = %Envelope{private: private = %Private{}}, %Clients.HTTP.Error{reason: :timeout}) do
    Belfrage.Metrics.multi_execute(
      [
        [:belfrage, :error, :service, platform_name(private), :timeout],
        [:belfrage, :platform, :response]
      ],
      %{count: 1},
      %{platform: platform_name(private), status_code: "408"}
    )

    log_error(:timeout, envelope)
  end

  defp track_error(envelope = %Envelope{private: private = %Private{}}, error = %Clients.HTTP.Error{}) do
    Belfrage.Metrics.multi_execute(
      [
        [:belfrage, :error, :service, platform_name(private), :request],
        [:belfrage, :error, :service, :request]
      ],
      %{count: 1},
      %{platform: platform_name(private)}
    )

    log_error(error, envelope)
  end

  defp platform_name(%Private{platform: platform}) do
    platform |> String.to_atom()
  end

  defp log_error(reason, envelope = %Envelope{}) do
    Logger.log(level(reason), "", %{
      msg: "HTTP Service request error",
      reason: reason,
      envelope: Envelope.loggable(envelope)
    })
  end

  defp level(:timeout), do: :warn
  defp level(_reason), do: :error
end
