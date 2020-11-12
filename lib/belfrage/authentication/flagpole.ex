defmodule Belfrage.Authentication.Flagpole do
  use GenServer

  @initial_state true
  @poll_rate 10_000

  def start_link(opts) do
    GenServer.start_link(
      __MODULE__,
      %{poll_rate: Keyword.get(opts, :poll_rate, @poll_rate)},
      name: Keyword.get(opts, :name, __MODULE__)
    )
  end

  @spec state(GenServer.server()) :: boolean()
  def state(server \\ __MODULE__), do: GenServer.call(server, :state)

  # Server callbacks

  @impl true
  def init(%{poll_rate: _rate}), do: {:ok, @initial_state}

  @impl GenServer
  def handle_call(:state, _from, state), do: {:reply, state, state}
end
