defmodule Belfrage.Dials.CircuitBreaker do
  @moduledoc false

  use GenServer

  @type state :: boolean

  @dial_key "circuit_breaker"

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @spec state() :: state
  def state(), do: GenServer.call(__MODULE__, :state)

  # Callbacks

  @impl GenServer
  @spec init(list) :: {:ok, state} | {:stop, term}
  def init(_opts) do
    case Belfrage.Dials.read_dials() do
      {:ok, %{@dial_key => "true"}} -> {:ok, true}
      {:ok, %{@dial_key => "false"}} -> {:ok, false}
      {:error, reason} -> {:stop, reason}
    end
  end

  @impl GenServer
  def handle_call(:state, _from, state), do: {:reply, state, state}

  @impl GenServer
  def handle_cast({:dials_changed, %{@dial_key => "true"}}, state), do: {:noreply, true}
  def handle_cast({:dials_changed, %{@dial_key => "false"}}, state), do: {:noreply, false}
  def handle_cast(_, state), do: {:noreply, state}
end
