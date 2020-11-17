defmodule Belfrage.Clients.Account do
  alias Belfrage.Clients

  @http_client Application.get_env(:belfrage, :http_client, Clients.HTTP)
  @json_codec Application.get_env(:belfrage, :json_codec)

  @callback get_jwk_keys() :: {:ok, map()} | {:error, term()}
  @callback get_idcta_config() :: {:ok, map()} | {:error, term()}

  defp auth_config do
    Application.get_env(:belfrage, :authentication)
  end

  def get_jwk_keys do
    # TODO: handle json decode errors
    case get_from_api(auth_config()["account_jwk_uri"]) do
      {:ok, keys} -> @json_codec.decode(keys)
      {:error, reason} -> {:error, reason}
    end
  end

  def get_idcta_config do
    # TODO: handle json decode errors
    case get_from_api(auth_config()["account_idcta_config_uri"], "IDCTA") do
      {:ok, config} -> @json_codec.decode(config)
      {:error, reason} -> {:error, reason}
    end
  end

  defp get_from_api(url, api \\ "JWK") do
    @http_client.execute(%Clients.HTTP.Request{
      method: :get,
      url: url
    })
    |> handle_response(api)
  end

  defp handle_response(http_response, api)

  defp handle_response({:ok, %Clients.HTTP.Response{status_code: 200, body: body}}, "JWK") do
    Stump.log(:info, "JWK keys fetched successfully", cloudwatch: true)
    {:ok, body}
  end

  defp handle_response({:ok, %Clients.HTTP.Response{status_code: 200, body: body}}, "IDCTA") do
    Stump.log(:info, "IDCTA config fetched successfully", cloudwatch: true)
    {:ok, body}
  end

  defp handle_response({:ok, %Clients.HTTP.Response{status_code: status_code}}, api) do
    Stump.log(:warn, "Non 200 Status Code (#{status_code}) from the #{api} API", cloudwatch: true)
    {:error, status_code}
  end

  defp handle_response({:ok, response}, api) do
    Stump.log(:warn, "Unknown response from the #{api} API #{response}", cloudwatch: true)
    {:error, "unknown response"}
  end

  defp handle_response({:error, %Clients.HTTP.Error{reason: reason}}, api) do
    Stump.log(:warn, "Error received from the #{api} API: #{reason}", cloudwatch: true)
    {:error, reason}
  end

  defp handle_response({:error, http_error}, api) do
    Stump.log(:warn, "Unknown error received from the #{api} API", cloudwatch: true)
    {:error, "unknown http error"}
  end
end
