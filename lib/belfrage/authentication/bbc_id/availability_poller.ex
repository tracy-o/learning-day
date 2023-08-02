defmodule Belfrage.Authentication.BBCID.AvailabilityPoller do
  @moduledoc """
  This process periodically gets the status of BBC ID services from the IDCTA
  config endpoint and updates the state of `Belfrage.Authentication.BBCID`
  process.
  """

  require Logger

  use Belfrage.Poller, interval: Application.compile_env!(:belfrage, :poller_intervals)[:bbc_id_availability]

  alias Belfrage.Authentication.BBCID

  @availability_states %{"GREEN" => true, "RED" => false}
  @client Application.compile_env(:belfrage, :json_client)
  @http_pool :AccountAuthentication

  @impl true
  def poll() do
    with {:ok, availability} <- get_availability() do
      BBCID.set_availability(availability)
    end

    :ok
  end

  defp get_availability() do
    with {:ok, config} <- @client.get(idcta_uri(), @http_pool, name: "idcta_config") do
      fetch_availability_from_config(config)
    end
  end

  defp idcta_uri, do: Application.get_env(:belfrage, :authentication)["idcta_config_uri"]

  defp fetch_availability_from_config(config) do
    with {:ok, state} <- Map.fetch(config, "id-availability"),
         {:ok, availability} <- Map.fetch(@availability_states, state) do
      {:ok, availability}
    else
      :error ->
        Logger.log(:error, "Couldn't determine BBC ID availability from IDCTA config: #{inspect(config)}")

        {:error, :availability_unknown}
    end
  end
end
