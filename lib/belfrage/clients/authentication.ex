defmodule Belfrage.Clients.Authentication do
  alias Belfrage.{Clients, Metrics}

  @http_client Application.get_env(:belfrage, :http_client, Clients.HTTP)
  @json_codec Application.get_env(:belfrage, :json_codec)

  @idcta_api_config_key "idcta_config_uri"
  @jwk_api_config_key "account_jwk_uri"

  @metrics %{
    "idcta_config_uri" => :idcta_config,
    "account_jwk_uri" => :jwk
  }

  @callback get_jwk_keys() :: {:ok, map()} | {:error, term()}
  @callback get_idcta_config() :: {:ok, map()} | {:error, term()}

  defp auth_config do
    Application.get_env(:belfrage, :authentication)
  end

  def get_jwk_keys do
    case get_from_api(auth_config()[@jwk_api_config_key], @jwk_api_config_key) do
      {:ok, keys} -> decode(keys, @jwk_api_config_key)
      {:error, reason} -> {:error, reason}
    end
  end

  def get_idcta_config do
    case get_from_api(auth_config()[@idcta_api_config_key], @idcta_api_config_key) do
      {:ok, config} -> decode(config, @idcta_api_config_key)
      {:error, reason} -> {:error, reason}
    end
  end

  defp get_from_api(url, api_config_name) do
    response =
      Metrics.duration([:request, Map.fetch!(@metrics, api_config_name)], fn ->
        @http_client.execute(
          %Clients.HTTP.Request{
            method: :get,
            url: url,
            headers: %{
              "connection" => "close"
            }
          },
          :AccountAuthentication
        )
      end)

    handle_response(response, api_config_name)
  end

  defp handle_response(http_response, api)

  defp handle_response({:ok, %Clients.HTTP.Response{status_code: 200, body: body}}, @jwk_api_config_key) do
    Stump.log(:info, "JWK keys fetched successfully", cloudwatch: true)
    {:ok, body}
  end

  defp handle_response({:ok, %Clients.HTTP.Response{status_code: 200, body: body}}, @idcta_api_config_key) do
    Stump.log(:info, "IDCTA config fetched successfully", cloudwatch: true)
    {:ok, body}
  end

  defp handle_response({:ok, %Clients.HTTP.Response{status_code: status_code}}, api) do
    Stump.log(:warn, "Non 200 Status Code (#{status_code}) from #{api}", cloudwatch: true)
    {:error, status_code}
  end

  defp handle_response({:ok, _response}, api) do
    Stump.log(:warn, "Unknown response from #{api}", cloudwatch: true)
    {:error, "unknown response"}
  end

  defp handle_response({:error, %Clients.HTTP.Error{reason: reason}}, api) do
    Stump.log(:warn, "Error received from #{api}: #{reason}", cloudwatch: true)
    {:error, reason}
  end

  defp handle_response({:error, _http_error}, api) do
    Stump.log(:warn, "Unknown error received from #{api}", cloudwatch: true)
    {:error, "unknown http error"}
  end

  defp decode(json_data, api_config_name) do
    case @json_codec.decode(json_data) do
      {:ok, json} ->
        {:ok, json}

      {:error, _exception} ->
        Stump.log(:warn, "Error while decoding data from #{api_config_name}", cloudwatch: true)
        {:error, "JSON decode error"}
    end
  end
end
