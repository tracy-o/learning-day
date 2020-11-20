defmodule Belfrage.Authentication.Flagpole do
  use GenServer

  @authentication_client Application.get_env(:belfrage, :authentication_client)

  @default_refresh_rate 10_000

  @states %{"GREEN" => true, "RED" => false}
  @idcta_state_key "id-availability"
  @idcta_states Map.keys(@states)

  @initial_state @states["GREEN"]

  @callback state() :: boolean

  def start_link(opts) do
    GenServer.start_link(
      __MODULE__,
      %{refresh_rate: Keyword.get(opts, :refresh_rate, @default_refresh_rate)},
      name: Keyword.get(opts, :name, __MODULE__)
    )
  end

  @spec state() :: boolean
  def state(), do: state(__MODULE__)

  @spec state(GenServer.server()) :: boolean
  def state(server), do: GenServer.call(server, :state)

  @spec refresh(GenServer.server()) :: any
  def refresh(server \\ __MODULE__), do: send(server, :refresh)

  # Server callbacks

  @impl true
  def init(%{refresh_rate: rate}) do
    schedule_work(self(), rate)
    {:ok, {rate, @initial_state}}
  end

  @impl true
  def handle_call(:state, _from, {rate, state}), do: {:reply, state, {rate, state}}

  @impl true
  def handle_info(:refresh, {rate, state}) do
    schedule_work(self(), rate)

    case @authentication_client.get_idcta_config() do
      {:ok, config} -> {:noreply, {rate, availability(config, state)}}
      {:error, _reason} -> {:noreply, {rate, state}}
    end
  end

  # Catch all to handle unexpected messages for now
  def handle_info(_any_message, state), do: {:noreply, state}

  defp availability(%{@idcta_state_key => new_state}, _state) when new_state in @idcta_states do
    @states[new_state]
  end

  defp availability(%{@idcta_state_key => new_state}, state) do
    Stump.log(:warn, "Unknown state: #{new_state}", cloudwatch: true)
    state
  end

  defp availability(_, state) do
    Stump.log(:warn, "idcta state unavailable in config", cloudwatch: true)
    state
  end

  defp schedule_work(server, rate), do: Process.send_after(server, :refresh, rate)
end
