defmodule Belfrage.Clients.Account do
  alias Belfrage.Clients

  @http_client Application.get_env(:belfrage, :http_client, Clients.HTTP)
  @json_codec Application.get_env(:belfrage, :json_codec)

  @callback get_jwk_keys() :: Struct.t()

  def get_jwk_keys do
    # @todo handle json decode errors
    case get_keys_from_api() do
      {:ok, keys} -> @json_codec.decode(keys)
      {:error, reason} -> {:error, reason}
    end
  end

  defp get_keys_from_api do
    @http_client.execute(%Clients.HTTP.Request{
      method: :get,
      url: auth_config()["account_jwk_uri"]
    })
    |> case do
      {:ok, %Clients.HTTP.Response{status_code: 200, body: body}} ->
        Stump.log(:info, "JWK keys fetched successfully", cloudwatch: true)
        {:ok, body}

      {:ok, %Clients.HTTP.Response{status_code: status_code}} ->
        Stump.log(:warn, "Non 200 Status Code (#{status_code}) from the JWK API", cloudwatch: true)
        {:error, status_code}

      {:ok, response} ->
        Stump.log(:warn, "Unknown response from the JWK API #{response}", cloudwatch: true)

        {:error, "unknown response"}

      {:error, %Clients.HTTP.Error{reason: reason}} ->
        Stump.log(:warn, "Error received from the JWK API: #{reason}", cloudwatch: true)

        {:error, reason}

      {:error, _http_error} ->
        Stump.log(:warn, "Unknown error received from the JWK API", cloudwatch: true)

        {:error, :unknown}
    end
  end

  defp auth_config do
    Application.get_env(:belfrage, :authentication)
  end
end