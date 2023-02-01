defmodule Belfrage.RouteSpecManager do
  use GenServer

  alias Belfrage.RouteSpec

  @route_spec_table :route_spec_table

  def start_link(opts), do: GenServer.start_link(__MODULE__, opts, name: __MODULE__)

  @spec get_spec(RouteSpec.route_state_id()) :: RouteSpec.t() | nil
  def get_spec(route_state_id) do
    GenServer.call(__MODULE__, {:get_spec, route_state_id})
  end

  @spec list_specs() :: [RouteSpec.t()]
  def list_specs(), do: GenServer.call(__MODULE__, :list_specs)

  @spec update_specs() :: :ok
  def update_specs(), do: GenServer.call(__MODULE__, :update)

  # callbacks
  @impl GenServer
  def init(_) do
    table_id = bootstrap_route_spec_table()
    do_update_specs(table_id)
    {:ok, %{route_spec_table_id: table_id}}
  end

  @impl GenServer
  def handle_call(:list_specs, _from, state = %{route_spec_table_id: table_id}) do
    specs = for {_id, spec} <- :ets.tab2list(table_id), do: spec
    {:reply, specs, state}
  end

  def handle_call({:get_spec, route_state_id}, _from, state = %{route_spec_table_id: table_id}) do
    result =
      case :ets.lookup(table_id, route_state_id) do
        [{_id, spec}] -> spec
        [] -> nil
      end

    {:reply, result, state}
  end

  def handle_call(:update, _from, state = %{route_spec_table_id: table_id}) do
    {:reply, do_update_specs(table_id), state}
  end

  defp do_update_specs(table_id), do: RouteSpec.list_route_specs() |> write_specs(table_id)

  defp write_specs(specs, table_id) do
    objects = for spec <- specs, do: {spec.route_state_id, spec}
    true = :ets.delete_all_objects(table_id)
    true = :ets.insert(table_id, objects)
    :ok
  end

  defp bootstrap_route_spec_table(), do: :ets.new(@route_spec_table, [:set])
end
