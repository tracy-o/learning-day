defmodule Belfrage.Clients.Json do
  require Logger
  alias Belfrage.{Clients, Metrics}

  @http_client Application.get_env(:belfrage, :http_client, Clients.HTTP)
  @json_codec Application.get_env(:belfrage, :json_codec)

  @callback get(url :: String.t(), api :: Atom.t(), pool_name :: Atom.t()) :: {:ok, map()} | {:error, term()}

  def get(url, api, pool_name) do
    case make_request(url, api, pool_name) do
      {:ok, data} -> decode(data, api)
      {:error, reason} -> {:error, reason}
    end
  end

  defp make_request(url, api, pool_name) do
    response =
      Metrics.duration([:request, String.to_atom(api.name)], fn ->
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

    handle_response(response, api)
  end

  defp handle_response({:ok, %Clients.HTTP.Response{status_code: 200, body: body}}, api) do
    Logger.log(:info, "#{api.name} polled successfully", cloudwatch: true)
    {:ok, body}
  end

  defp handle_response({:ok, %Clients.HTTP.Response{status_code: status_code}}, api) do
    Logger.log(:warn, "Non 200 Status Code (#{status_code}) from #{api.name}", cloudwatch: true)
    {:error, status_code}
  end

  defp handle_response({:ok, _response}, api) do
    Logger.log(:warn, "Unknown response from #{api.name}", cloudwatch: true)
    {:error, "unknown response"}
  end

  defp handle_response({:error, %Clients.HTTP.Error{reason: reason}}, api) do
    Logger.log(:warn, "Error received from #{api.name}: #{reason}", cloudwatch: true)
    {:error, reason}
  end

  defp handle_response({:error, _http_error}, api) do
    Logger.log(:warn, "Unknown error received from #{api.name}", cloudwatch: true)
    {:error, "unknown http error"}
  end

  defp decode(json_data, api) do
    {:ok, @json_codec.decode!(json_data)}
  rescue
    _exception ->
      Logger.log(:warn, "Error while decoding data from #{api.name}", cloudwatch: true)
      {:error, "JSON decode error"}
  end
end
