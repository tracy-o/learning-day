defmodule Belfrage.Clients.Json do
  alias Belfrage.{Clients, Metrics}

  @http_client Application.get_env(:belfrage, :http_client, Clients.HTTP)
  @json_codec Application.get_env(:belfrage, :json_codec)

  @callback get(url :: String.t(), api_name :: String.t(), pool_name :: Atom.t()) :: {:ok, map()} | {:error, term()}

  def get(url, api_name, pool_name) do
    case make_request(url, api_name, pool_name) do
      {:ok, data} -> decode(data, api_name)
      {:error, reason} -> {:error, reason}
    end
  end

  defp make_request(url, api_name, pool_name) do
    response =
      Metrics.duration([:request, String.to_atom(api_name)], fn ->
        @http_client.execute(
          %Clients.HTTP.Request{
            method: :get,
            url: url,
            headers: %{
              "connection" => "close"
            }
          },
          pool_name
        )
      end)

    handle_response(response, api_name)
  end

  defp handle_response(http_response, api_name)

  defp handle_response({:ok, %Clients.HTTP.Response{status_code: 200, body: body}}, "jwk") do
    Stump.log(:info, "JWK keys fetched successfully", cloudwatch: true)
    {:ok, body}
  end

  defp handle_response({:ok, %Clients.HTTP.Response{status_code: 200, body: body}}, "idcta_config") do
    Stump.log(:info, "IDCTA config fetched successfully", cloudwatch: true)
    {:ok, body}
  end

  defp handle_response({:ok, %Clients.HTTP.Response{status_code: status_code}}, api_name) do
    Stump.log(:warn, "Non 200 Status Code (#{status_code}) from #{api_name}", cloudwatch: true)
    {:error, status_code}
  end

  defp handle_response({:ok, _response}, api_name) do
    Stump.log(:warn, "Unknown response from #{api_name}", cloudwatch: true)
    {:error, "unknown response"}
  end

  defp handle_response({:error, %Clients.HTTP.Error{reason: reason}}, api_name) do
    Stump.log(:warn, "Error received from #{api_name}: #{reason}", cloudwatch: true)
    {:error, reason}
  end

  defp handle_response({:error, _http_error}, api_name) do
    Stump.log(:warn, "Unknown error received from #{api_name}", cloudwatch: true)
    {:error, "unknown http error"}
  end

  defp decode(json_data, api_name) do
    case @json_codec.decode(json_data) do
      {:ok, json} ->
        {:ok, json}

      {:error, _exception} ->
        Stump.log(:warn, "Error while decoding data from #{api_name}", cloudwatch: true)
        {:error, "JSON decode error"}
    end
  end
end
