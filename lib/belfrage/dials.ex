defmodule Belfrage.Dials do
  use GenServer

  @dials_location Application.get_env(:belfrage, :dials_location)
  @refresh_rate 60_000

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: :dials)
  end

  def state() do
    GenServer.call(:dials, :state)
  end

  @impl GenServer
  def init(initial_state) do
    send(self(), :refresh)
    {:ok, initial_state}
  end

  @impl GenServer
  def handle_info(:refresh, _old_dials) do
    schedule_work()

    {:noreply, refresh_dials()}
  end

  # Catch all to handle unexpected messages
  # https://elixir-lang.org/getting-started/mix-otp/genserver.html#call-cast-or-info
  @impl GenServer
  def handle_info(_any_message, state) do
    {:noreply, state}
  end

  @impl GenServer
  def handle_call(:state, _from, dials) do
    {:reply, dials, dials}
  end

  defp schedule_work do
    Process.send_after(self(), :refresh, @refresh_rate)
  end

  defp refresh_dials do
    Eljiffy.decode!(File.read!(@dials_location))
  end
end
