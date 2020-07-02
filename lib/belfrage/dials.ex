defmodule Belfrage.Dials do
  @moduledoc """
  This module is responsible for adding dials to the dials supervisor,
  polling/reading Cosmos dials.json and invokes dials changed event via
  the supervisor.
  """

  use GenServer

  alias Belfrage.DialsSupervisor

  @dials_location Application.get_env(:belfrage, :dials_location)
  @json_codec Application.get_env(:belfrage, :json_codec)
  @file_io Application.get_env(:belfrage, :file_io)
  @refresh_rate 30_000

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: :dials)
  end

  def state() do
    GenServer.call(:dials, :state)
  end

  def clear() do
    GenServer.call(:dials, :clear)
  end

  def refresh_now() do
    Process.send(:dials, :refresh, [])
  end

  @impl GenServer
  def init(_opts) do
    send(self(), :refresh)
    {:ok, %{}}
  end

  @impl GenServer
  def handle_info(:refresh, old_dials) do
    schedule_work()

    case read_dials() do
      {:ok, dials} when dials != old_dials ->
        # TODO: to be removed when TTL, log level dials are updated: RESFRAME-3594, RESFRAME-3596
        on_refresh(dials)
        DialsSupervisor.notify(:dials_changed, dials)

        {:noreply, dials}

      {:ok, dials} when dials == old_dials ->
        {:noreply, old_dials}

      {:error, reason} ->
        Stump.log(
          :error,
          %{
            msg: "Unable to read dials",
            reason: reason
          }
        )

        {:noreply, old_dials}
    end
  end

  # Catch all to handle unexpected messages
  # https://elixir-lang.org/getting-started/mix-otp/genserver.html#call-cast-or-info
  @impl GenServer
  def handle_info(_any_message, state) do
    {:noreply, state}
  end

  @impl GenServer
  def handle_call(:state, _from, dials) when is_map(dials) do
    {:reply, dials, dials}
  end

  @impl GenServer
  def handle_call(:clear, _from, _state) do
    {:reply, %{}, %{}}
  end

  defp schedule_work do
    Process.send_after(:dials, :refresh, @refresh_rate)
  end

  defp read_dials() do
    case @file_io.read(@dials_location) do
      {:ok, dials_file_contents} -> @json_codec.decode(dials_file_contents)
      {:error, reason} -> {:error, reason}
    end
  end

  defp on_refresh(dials) do
    Belfrage.Dials.LoggingLevel.on_refresh(dials)
    :ok
  end
end
