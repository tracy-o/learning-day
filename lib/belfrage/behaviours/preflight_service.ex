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
    cache_key = preflight_service_callback(service).cache_key(envelope)

    case Cache.PreflightMetadata.get(service, cache_key) do
      {:ok, metadata} ->
        {:ok, metadata}

      {:error, :preflight_data_not_found} ->
        case make_request(envelope, service) do
          {:ok, response = %HTTP.Response{status_code: 200}} ->
            decode_handle_response(response, service, cache_key)

          {:ok, %HTTP.Response{status_code: status_code}} when status_code in [404, 410] ->
            {:error, :preflight_data_not_found}

          {:ok, response = %HTTP.Response{}} ->
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
          handle_data_error("'#{service}' failed to handle response}", response, reason)
      end
    rescue
      reason -> handle_data_error("Unable to parse preflight JSON", response, reason)
    end
  end

  defp make_request(envelope, service) do
    request = preflight_service_callback(service).request(envelope)
    @http_client.execute(struct!(HTTP.Request, request), :Preflight)
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
end
