defmodule Belfrage.Clients.Json do
  require Logger
  alias Belfrage.{Clients, Metrics}

  @http_client Application.get_env(:belfrage, :http_client, Clients.HTTP)
  @json_codec Application.get_env(:belfrage, :json_codec)

  @callback get(url :: String.t(), pool_name :: Atom.t(), opts :: List.t()) :: {:ok, map()} | {:error, term()}

  def get(url, pool_name, opts) do
    metadata = Keyword.take(opts, [:name])

    case make_request(url, pool_name, metadata[:name]) do
      {:ok, data} -> decode(data, metadata[:name])
      {:error, reason} -> {:error, reason}
    end
  end

  defp make_request(url, pool_name, poller_name) do
    response =
      Metrics.duration([:request, String.to_atom(poller_name)], fn ->
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

    handle_response(response, poller_name)
  end

  defp handle_response({:ok, %Clients.HTTP.Response{status_code: 200, body: body}}, poller_name) do
    Logger.log(:info, "#{poller_name} polled successfully", cloudwatch: true)
    {:ok, body}
  end

  defp handle_response({:ok, %Clients.HTTP.Response{status_code: status_code}}, poller_name) do
    Logger.log(:warn, "Non 200 Status Code (#{status_code}) from #{poller_name}", cloudwatch: true)
    {:error, status_code}
  end

  defp handle_response({:ok, _response}, poller_name) do
    Logger.log(:warn, "Unknown response from #{poller_name}", cloudwatch: true)
    {:error, "unknown response"}
  end

  defp handle_response({:error, %Clients.HTTP.Error{reason: reason}}, poller_name) do
    Logger.log(:warn, "Error received from #{poller_name}: #{reason}", cloudwatch: true)
    {:error, reason}
  end

  defp handle_response({:error, _http_error}, poller_name) do
    Logger.log(:warn, "Unknown error received from #{poller_name}", cloudwatch: true)
    {:error, "unknown http error"}
  end

  defp decode(json_data, poller_name) do
    {:ok, @json_codec.decode!(json_data)}
  rescue
    _exception ->
      Logger.log(:warn, "Error while decoding data from #{poller_name}", cloudwatch: true)
      {:error, "JSON decode error"}
  end
end
