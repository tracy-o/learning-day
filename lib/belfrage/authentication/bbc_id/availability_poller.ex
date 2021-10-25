defmodule Belfrage.Authentication.BBCID.AvailabilityPoller do
  @moduledoc """
  This process periodically gets the status of BBC ID services from the IDCTA
  config endpoint and updates the state of `Belfrage.Authentication.BBCID`
  process.
  """

  use GenServer

  alias Belfrage.Authentication.BBCID

  @interval Application.get_env(:belfrage, :bbc_id_availability_poll_interval)
  @auth_client Application.get_env(:belfrage, :authentication_client)
  @availability_states %{"GREEN" => true, "RED" => false}

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, Keyword.get(opts, :interval, @interval))
  end

  @impl true
  def init(interval) do
    schedule_polling(interval)
    {:ok, interval}
  end

  def get_availability() do
    with {:ok, config} <- @auth_client.get_idcta_config() do
      fetch_availability_from_config(config)
    end
  end

  defp schedule_polling(interval) do
    Process.send_after(self(), :poll, interval)
  end

  @impl true
  def handle_info(:poll, interval) do
    schedule_polling(interval)

    with {:ok, availability} <- get_availability() do
      BBCID.set_availability(availability)
    end

    {:noreply, interval}
  end

  defp fetch_availability_from_config(config) do
    with {:ok, state} <- Map.fetch(config, "id-availability"),
         {:ok, availability} <- Map.fetch(@availability_states, state) do
      {:ok, availability}
    else
      :error ->
        Stump.log(:warn, "Couldn't determine BBC ID availability from IDCTA config: #{inspect(config)}",
          cloudwatch: true
        )

        {:error, :availability_unknown}
    end
  end
end