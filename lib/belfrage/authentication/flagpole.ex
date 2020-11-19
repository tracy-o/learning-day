defmodule Belfrage.Authentication.Flagpole do
  use GenServer

  @authentication_client Application.get_env(:belfrage, :authentication_client)

  @default_poll_rate 10_000

  @states %{"GREEN" => true, "RED" => false}
  @idcta_state_key "id-availability"
  @idcta_states Map.keys(@states)

  @initial_state @states["GREEN"]

  def start_link(opts) do
    GenServer.start_link(
      __MODULE__,
      %{poll_rate: Keyword.get(opts, :poll_rate, @default_poll_rate)},
      name: Keyword.get(opts, :name, __MODULE__)
    )
  end

  @spec state(GenServer.server()) :: boolean
  def state(server \\ __MODULE__), do: GenServer.call(server, :state)

  @spec poll(GenServer.server()) :: any
  def poll(server \\ __MODULE__), do: send(server, :poll)

  # Server callbacks

  @impl true
  def init(%{poll_rate: rate}) do
    schedule_work(self(), rate)
    {:ok, {rate, @initial_state}}
  end

  @impl true
  def handle_call(:state, _from, {rate, state}), do: {:reply, state, {rate, state}}

  @impl true
  def handle_info(:poll, {rate, state}) do
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

  defp schedule_work(server, rate), do: Process.send_after(server, :poll, rate)
end
