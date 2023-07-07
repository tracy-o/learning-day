defmodule Belfrage.Behaviours.PreflightService do
  alias Belfrage.Envelope
  alias Belfrage.Cache
  alias Belfrage.Clients.HTTP
  alias Belfrage.Envelope

  require Logger

  @callback request(Envelope.t()) :: map()
  @callback cache_key(Envelope.t()) :: binary()
  @callback handle_response(any()) :: {:ok, any()} | {:error, atom()}

  @http_client Application.compile_env(:belfrage, :http_client, HTTP)

  @spec call(Envelope.t(), String.t()) :: {:ok, any()} | {:error, atom()}
  def call(envelope, service) do
    metric([:preflight, :request], %{preflight_service: service})
    cache_key = preflight_service_callback(service).cache_key(envelope)

    case Cache.PreflightMetadata.get(service, cache_key) do
      {:ok, metadata} ->
        {:ok, metadata}

      {:error, :preflight_data_not_found} ->
        case make_request(envelope, service) do
          {:ok, response = %HTTP.Response{status_code: 200}} ->
            metric([:preflight, :response], %{preflight_service: service, status_code: 200})
            decode_handle_response(response, service, cache_key)

          {:ok, %HTTP.Response{status_code: status_code}} when status_code in [404, 410] ->
            metric([:preflight, :response], %{preflight_service: service, status_code: status_code})
            {:error, :preflight_data_not_found}

          {:ok, response = %HTTP.Response{status_code: status_code}} ->
            metric([:preflight, :response], %{preflight_service: service, status_code: status_code})
            handle_data_error("HTTP Preflight Service unaccepted status code", response, nil)

          {:error, reason} ->
            handle_data_error("HTTP Preflight Service unaccepted status code", nil, reason)
        end
    end
  end

  defp decode_handle_response(response = %HTTP.Response{body: payload}, service, cache_key) do
    try do
      decoded = Json.decode!(payload)

      case preflight_service_callback(service).handle_response(decoded) do
        {:ok, data} ->
          Cache.PreflightMetadata.put(service, cache_key, data)
          {:ok, data}

        {:error, reason} ->
          metric([:preflight, :error], %{preflight_service: service, error_type: "invalid_response"})
          handle_data_error("'#{service}' failed to handle response}", response, reason)
      end
    rescue
      reason ->
        metric([:preflight, :error], %{preflight_service: service, error_type: "json_parse"})
        handle_data_error("Unable to parse preflight JSON", response, reason)
    end
  end

  defp make_request(envelope, service) do
    before_time = System.monotonic_time(:millisecond)
    request = preflight_service_callback(service).request(envelope)
    {state, response} = @http_client.execute(struct!(HTTP.Request, request), :Preflight)
    timing = (System.monotonic_time(:millisecond) - before_time) |> abs

    metric([:preflight, :request, :timing], %{duration: timing}, %{
      preflight_service: service,
      status_code: Map.get(response, :status_code, "500")
    })

    {state, response}
  end

  defp preflight_service_callback(preflight_service) do
    Module.concat([Belfrage, PreflightServices, preflight_service])
  end

  defp handle_data_error(message, response, reason) do
    Logger.log(:error, "", %{
      msg: message,
      response: response,
      reason: reason
    })

    {:error, :preflight_data_error}
  end

  defp metric(metric, measurement \\ %{}, dimensions) do
    :telemetry.execute(metric, measurement, dimensions)
  end
end
