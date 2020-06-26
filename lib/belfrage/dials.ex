defmodule Belfrage.Dials do
  @module_doc """
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

    sup = start_supervisor()
    DialsSupervisor.add_dials(sup)

    {:ok, %{manager: sup, dials: %{}}}
  end

  defp start_supervisor() do
    case DialsSupervisor.start_link() do
      {:ok, pid} -> pid
      {:error, {:already_started, pid}} -> pid
    end
  end

  @impl GenServer
  def handle_info(:refresh, state) do
    schedule_work()

    old_dials = state.dials

    case read_dials() do
      {:ok, dials} when dials != old_dials ->
        # TODO: to be removed when TTL, log level dials are updated
        on_refresh(dials)
        DialsSupervisor.notify(state.manager, :dials_changed, dials)

        {:noreply, %{state | dials: dials}}

      {:ok, dials} when dials == old_dials ->
        {:noreply, state}

      {:error, reason} ->
        Stump.log(
          :error,
          %{
            msg: "Unable to read dials",
            reason: reason
          }
        )

        {:noreply, state}
    end
  end

  # Catch all to handle unexpected messages
  # https://elixir-lang.org/getting-started/mix-otp/genserver.html#call-cast-or-info
  @impl GenServer
  def handle_info(_any_message, state) do
    {:noreply, state}
  end

  @impl GenServer
  def handle_call(:state, _from, %{dials: dials} = state) when is_map(dials) do
    {:reply, dials, state}
  end

  @impl GenServer
  def handle_call(:clear, _from, state) do
    {:reply, %{state | dials: %{}}, %{state | dials: %{}}}
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
