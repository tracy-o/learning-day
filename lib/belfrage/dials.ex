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

  def refresh_now() do
    Process.send(:dials, :refresh, [])
  end

  @impl GenServer
  def init(initial_state) do
    send(self(), :refresh)
    {:ok, initial_state}
  end

  @impl GenServer
  def handle_info(:refresh, old_dials) do
    schedule_work()

    case refresh_dials() do
      {:ok, dials} -> {:noreply, dials}
      {:error, _reason} -> {:noreply, old_dials}
    end
  end

  # Catch all to handle unexpected messages
  # https://elixir-lang.org/getting-started/mix-otp/genserver.html#call-cast-or-info
  @impl GenServer
  def handle_info(_any_message, dials) do
    {:noreply, dials}
  end

  @impl GenServer
  def handle_call(:state, _from, dials) when is_map(dials) do
    {:reply, dials, dials}
  end

  @impl GenServer
  def handle_call(:state, _from, _state) do
    {:reply, %{}, %{}}
  end

  defp schedule_work do
    Process.send_after(:dials, :refresh, @refresh_rate)
  end

  defp refresh_dials do
    case File.read(@dials_location) do
      {:ok, dials_file_contents} -> Eljiffy.decode(dials_file_contents)
      {:error, reason} -> {:error, reason}
    end
  end
end
