defmodule Belfrage.Clients.Account do
  alias Belfrage.Clients

  @http_client Application.get_env(:belfrage, :http_client, Clients.HTTP)
  @json_codec Application.get_env(:belfrage, :json_codec)

  @callback get_jwk_keys() :: {:ok, map()} | {:error, term()}

  defp auth_config do
    Application.get_env(:belfrage, :authentication)
  end

  def get_jwk_keys do
    # @todo handle json decode errors
    case get_from_api(auth_config()["account_jwk_uri"]) do
      {:ok, keys} -> @json_codec.decode(keys)
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

  defp handle_response({:ok, %Clients.HTTP.Response{status_code: status_code}}, api) do
    Stump.log(:warn, "Non 200 Status Code (#{status_code}) from the #{api} API", cloudwatch: true)
    {:error, status_code}
  end

  defp handle_response({:ok, response}, api) do
    Stump.log(:warn, "Unknown response from the #{api} API #{response}", cloudwatch: true)
    {:error, "unknown response"}
  end

  # TODO: note #{http_error} a potential issue since http_error is unknown type
  # i.e. to_string(http_error) not guaranteed
  defp handle_response({:error, http_error}, api) do
    Stump.log(:warn, "Error received from the #{api} API: #{http_error}", cloudwatch: true)
    {:error, http_error}
  end
end
