defmodule Belfrage.Behaviours.PreflightService do
  alias Belfrage.{Envelope, Cache, Clients.HTTP, Envelope, Metrics.LatencyMonitor}

  require Logger

  @callback request(Envelope.t()) :: map()
  @callback cache_key(Envelope.t()) :: binary()
  @callback handle_response(any()) :: {:ok, any()} | {:error, atom()}

  @http_client Application.compile_env(:belfrage, :http_client, HTTP)

  @spec call(Envelope.t(), String.t()) :: {:ok, Envelope.t(), any()} | {:error, atom()}
  def call(envelope, service) do
    metric([:preflight, :request], %{preflight_service: service})
    cache_key = preflight_service_callback(service).cache_key(envelope)

    case Cache.PreflightMetadata.get(service, cache_key) do
      {:ok, metadata} ->
        {:ok, envelope, metadata}

      {:error, :preflight_data_not_found} ->
        case make_request(envelope, service) do
          {:ok, envelope, response = %HTTP.Response{status_code: 200}} ->
            metric([:preflight, :response], %{preflight_service: service, status_code: 200})
            decode_handle_response(response, service, cache_key, envelope)

          {:ok, envelope, response = %HTTP.Response{status_code: status_code}} when status_code in [404, 410] ->
            metric([:preflight, :response], %{preflight_service: service, status_code: status_code})
            handle_not_found(response, service, envelope)

          {:ok, envelope, response = %HTTP.Response{status_code: status_code}} ->
            metric([:preflight, :response], %{preflight_service: service, status_code: status_code})
            handle_error(:preflight_unacceptable_status_code, response, nil, service, envelope)

          {:error, envelope, reason} ->
            handle_error(:preflight_unacceptable_status_code, nil, reason, service, envelope)
        end
    end
  end

  defp decode_handle_response(response = %HTTP.Response{body: payload}, service, cache_key, envelope) do
    try do
      decoded = Json.decode!(payload)

      case preflight_service_callback(service).handle_response(decoded) do
        {:ok, data} ->
          Cache.PreflightMetadata.put(service, cache_key, data)
          {:ok, envelope, data}

        {:error, reason} ->
          metric([:preflight, :error], %{preflight_service: service, error_type: "invalid_response"})
          handle_error(:preflight_data_mismatch, response, reason, service, envelope)
      end
    rescue
      reason ->
        metric([:preflight, :error], %{preflight_service: service, error_type: "json_parse"})
        handle_error(:preflight_data_parse_error, response, reason, service, envelope)
    end
  end

  defp make_request(envelope, service) do
    before_time = System.monotonic_time(:millisecond)
    request = preflight_service_callback(service).request(envelope)
    {state, response} = @http_client.execute(struct!(HTTP.Request, request), :Preflight)
    timing = (System.monotonic_time(:millisecond) - before_time) |> abs

    envelope = LatencyMonitor.checkpoint(envelope, :preflight_service_request_timing, timing)

    metric([:preflight, :request, :timing], %{duration: timing}, %{
      preflight_service: service,
      status_code: Map.get(response, :status_code, "500")
    })

    {state, envelope, response}
  end

  defp preflight_service_callback(preflight_service) do
    Module.concat([Belfrage, PreflightServices, preflight_service])
  end

  defp handle_error(error_description, response, reason, service, %Envelope{
         request: %Envelope.Request{path: path}
       }) do
    Logger.log(:error, "", %{
      preflight_error: error_description,
      response_status: get_status_code(response),
      reason: reason,
      service: service,
      request_path: path
    })

    {:error, :preflight_data_error}
  end

  defp handle_not_found(%HTTP.Response{status_code: status_code}, service, %Envelope{
         request: %Envelope.Request{path: path}
       }) do
    Logger.log(:error, "", %{
      preflight_error: :data_not_found,
      response_status: status_code,
      service: service,
      request_path: path
    })

    {:error, :preflight_data_not_found}
  end

  defp get_status_code(%HTTP.Response{status_code: status_code}), do: status_code
  defp get_status_code(_), do: nil

  defp metric(metric, measurement \\ %{}, dimensions) do
    :telemetry.execute(metric, measurement, dimensions)
  end
end
