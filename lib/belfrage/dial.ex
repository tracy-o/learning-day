defmodule Belfrage.Dial do
  @callback transform(any()) :: any()
  @callback on_change(any()) :: :ok
  @optional_callbacks on_change: 1

  @type state :: {atom(), any()}

  use GenServer

  def start_link(opts) do
    {_dial_logic_mod, dial_name, _init_value} = opts
    GenServer.start_link(__MODULE__, opts, name: dial_name)
  end

  @spec state(atom()) :: state
  def state(dial), do: GenServer.call(dial, :state)

  # Callbacks

  @impl GenServer
  @spec init(list) :: {:ok, state}
  def init(opts) do
    {dial_logic_mod, dial_name, init_value} = opts

    {:ok, {dial_logic_mod, to_string(dial_name), dial_logic_mod.transform(init_value)}}
  end

  @impl GenServer
  def handle_call(:state, _from, state = {_dial_logic_mod, _dial_name, value}), do: {:reply, value, state}

  @impl GenServer
  def handle_cast({:dials_changed, changes}, state = {dial_logic_mod, dial_name, _old_value}) do
    case changes do
      %{^dial_name => value} ->
        transformed_value = dial_logic_mod.transform(value)
        maybe_call_on_change(dial_logic_mod, transformed_value)

        {:noreply, {dial_logic_mod, dial_name, transformed_value}}

      _other ->
        {:noreply, state}
    end
  end

  defp maybe_call_on_change(dial_logic_mod, transformed_value) do
    if function_exported?(dial_logic_mod, :on_change, 1) do
      apply(dial_logic_mod, :on_change, [transformed_value])
    end
  end
end
