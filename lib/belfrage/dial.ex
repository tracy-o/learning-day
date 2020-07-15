defmodule Belfrage.Dial do
  @callback transform(any()) :: any()
  @callback name() :: String.t()

  @codec Application.get_env(:belfrage, :json_codec)
  @file_io Application.get_env(:belfrage, :file_io)

  @type state :: {atom(), any()}

  use GenServer
  import Logger

  def start_link(opts = [dial: dial, name: name]) do
    GenServer.start_link(__MODULE__, opts, name: name)
  end

  @spec state(atom()) :: state
  def state(dial), do: GenServer.call(dial, :state)

  def default(dial_logic_mod) do
    dial_config()
    |> Enum.find(&(&1["name"] == dial_logic_mod.name()))
    |> Map.get("default-value")
    |> dial_logic_mod.transform()
  end

  # Callbacks

  @impl GenServer
  @spec init(list) :: {:ok, state}
  def init(dial: dial_logic_mod, name: _name) do
    # initial state inferred from Cosmos dials.json
    # via default() injected from Belfrage.Dials.Defaults
    # the state is to be overriden by the current dial value
    # immediately by "dials_changed" event

    {:ok, {dial_logic_mod, default(dial_logic_mod)}}
  end

  @impl GenServer
  def handle_call(:state, _from, state = {_dial_logic_mod, value}), do: {:reply, value, state}

  @impl GenServer
  def handle_cast({:dials_changed, changes}, state = {dial_logic_mod, _old_value}) do
    dial_name = dial_logic_mod.name()

    case changes do
      %{^dial_name => value} ->
        {:noreply, {dial_logic_mod, dial_logic_mod.transform(value)}}

      _other ->
        {:noreply, state}
    end
  end

  def dial_config do
    Application.app_dir(:belfrage, "priv/static/dials.json")
    |> @file_io.read!()
    |> @codec.decode!()
  end
end
