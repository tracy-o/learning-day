defmodule Belfrage.Services.Webcore.Credentials.Poller do
  @moduledoc """
  This module periodically gets the credentials for calling the Webcore lambda
  from the configured source and updates them in
  `Belfrage.Services.Webcore.Credentials` process.
  """

  use GenServer

  alias Belfrage.Services.Webcore.Credentials

  @interval 600_000
  @source Application.get_env(:belfrage, :webcore_credentials_source)

  def start_link(opts \\ []) do
    state = {
      Keyword.get(opts, :source, @source),
      Keyword.get(opts, :interval, @interval)
    }

    GenServer.start_link(__MODULE__, state, name: Keyword.get(opts, :name, __MODULE__))
  end

  @impl true
  def init(state = {_source, interval}) do
    schedule_polling(interval)
    {:ok, state}
  end

  defp schedule_polling(interval) do
    Process.send_after(self(), :poll, interval)
  end

  @impl true
  def handle_info(:poll, state = {source, interval}) do
    schedule_polling(interval)

    with {:ok, credentials} <- source.get() do
      Credentials.update(credentials)
    end

    {:noreply, state}
  end
end
