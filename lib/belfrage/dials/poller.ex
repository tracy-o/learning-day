defmodule Belfrage.Dials.Poller do
  @moduledoc false

  use GenServer

  @dials_location Application.get_env(:belfrage, :dials_location)
  @json_codec Application.get_env(:belfrage, :json_codec)
  @file_io Application.get_env(:belfrage, :file_io)
  @refresh_rate 5_000

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def state() do
    GenServer.call(__MODULE__, :state)
  end

  def clear() do
    GenServer.call(__MODULE__, :clear)
  end

  def refresh_now() do
    Process.send(__MODULE__, :refresh, [])
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
      {:ok, dials} ->
        Belfrage.DialsSupervisor.notify(:dials_changed, dials)

        {:noreply, dials}

      {:error, reason} ->
        Belfrage.Event.record(:log, :error, %{
          msg: "Unable to read dials",
          reason: reason
        })

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
    Process.send_after(__MODULE__, :refresh, @refresh_rate)
  end

  defp read_dials() do
    case @file_io.read(@dials_location) do
      {:ok, dials_file_contents} -> @json_codec.decode(dials_file_contents)
      {:error, reason} -> {:error, reason}
    end
  end
end
