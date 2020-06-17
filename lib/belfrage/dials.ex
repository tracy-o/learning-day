defmodule Belfrage.Dials do
  use GenServer

  @dials_location Application.get_env(:belfrage, :dials_location)
  @json_codec Application.get_env(:belfrage, :json_codec)
  @file_io Application.get_env(:belfrage, :file_io)
  @refresh_rate 30_000

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: :dials)
  end

  def logging_level() do
    state()
    |> Map.get("logging_level", "default")
    |> set_level()
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

    case refresh_dials() do
      {:ok, dials} ->
        {:noreply, dials}

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
  def handle_info(_any_message, dials) do
    {:noreply, dials}
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

  defp refresh_dials do
    case @file_io.read(@dials_location) do
      {:ok, dials_file_contents} -> @json_codec.decode(dials_file_contents)
      {:error, reason} -> {:error, reason}
    end
  end

  defp set_level(dial_value) do
    dial = String.to_atom(dial_value)

    if dial in [:debug, :info, :warn, :error] do
      Logger.configure(level: dial)
    end

    Logger.level()
  end
end
