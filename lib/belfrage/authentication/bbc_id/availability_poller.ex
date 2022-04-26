defmodule Belfrage.Authentication.BBCID.AvailabilityPoller do
  @moduledoc """
  This process periodically gets the status of BBC ID services from the IDCTA
  config endpoint and updates the state of `Belfrage.Authentication.BBCID`
  process.
  """

  require Logger

  use GenServer

  alias Belfrage.Authentication.BBCID

  @interval Application.get_env(:belfrage, :bbc_id_availability_poll_interval)
  @availability_states %{"GREEN" => true, "RED" => false}
  @client Application.get_env(:belfrage, :json_client)
  @http_pool :AccountAuthentication

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, Keyword.get(opts, :interval, @interval), name: Keyword.get(opts, :name, __MODULE__))
  end

  @impl true
  def init(interval) do
    schedule_polling(interval)
    {:ok, interval}
  end

  @impl true
  def handle_info(:poll, interval) do
    schedule_polling(interval)

    with {:ok, availability} <- get_availability() do
      BBCID.set_availability(availability)
    end

    {:noreply, interval}
  end

  defp get_availability() do
    with {:ok, config} <- @client.get(idcta_uri(), @http_pool, name: "idcta_config") do
      fetch_availability_from_config(config)
    end
  end

  defp idcta_uri, do: Application.get_env(:belfrage, :authentication)["idcta_config_uri"]

  defp schedule_polling(interval) do
    Process.send_after(self(), :poll, interval)
  end

  defp fetch_availability_from_config(config) do
    with {:ok, state} <- Map.fetch(config, "id-availability"),
         {:ok, availability} <- Map.fetch(@availability_states, state) do
      {:ok, availability}
    else
      :error ->
        Logger.log(:warn, "Couldn't determine BBC ID availability from IDCTA config: #{inspect(config)}",
          cloudwatch: true
        )

        {:error, :availability_unknown}
    end
  end
end
