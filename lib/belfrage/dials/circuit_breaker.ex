defmodule Belfrage.Dials.CircuitBreaker do
  @moduledoc false

  use GenServer

  # TODO: update to Belfrage.Dials.Dial in https://jira.dev.bbc.co.uk/browse/RESFRAME-3592
  use Belfrage.Dials.Defaults, dial: "circuit_breaker"

  @type state :: boolean

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @spec state() :: state
  def state(), do: GenServer.call(__MODULE__, :state)

  # Callbacks

  @impl GenServer
  @spec init(list) :: {:ok, state}
  def init(_opts) do
    # initial state inferred from Cosmos dials.json
    # via default() injected from Belfrage.Dials.Defaults
    # the state is to be overriden by the current dial value
    # immediately by "dials_changed" event
    {:ok, default()}
  end

  @impl GenServer
  def handle_call(:state, _from, state), do: {:reply, state, state}

  @impl GenServer
  def handle_cast({:dials_changed, %{@dial => value}}, _state), do: {:noreply, transform(value, @dial)}
  def handle_cast(_, state), do: {:noreply, state}
end
