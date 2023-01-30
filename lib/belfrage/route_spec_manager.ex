defmodule Belfrage.RouteSpecManager do
  use GenServer

  alias Belfrage.RouteSpec
  require Logger

  @route_spec_table :route_spec_table

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @spec get_spec(RouteSpec.route_state_id()) :: RouteSpec.t() | nil
  def get_spec(route_state_id) do
    case GenServer.call(__MODULE__, {:get_spec, route_state_id}) do
      nil -> report_spec_not_found(route_state_id)
      spec -> spec
    end
  end

  @spec list_specs() :: [RouteSpec.t()]
  def list_specs() do
    GenServer.call(__MODULE__, :list_specs)
  end

  @spec update_specs() :: :ok
  def update_specs() do
    GenServer.cast(__MODULE__, :update)
  end

  # callbacks
  @impl GenServer
  def init(_) do
    prod_env = Application.get_env(:belfrage, :production_environment)
    table_id = bootstrap_route_spec_table()
    do_update_specs(prod_env, table_id)
    {:ok, %{env: prod_env, route_spec_table_id: table_id}}
  end

  @impl GenServer
  def handle_call(:list_specs, _, state = %{route_spec_table_id: table_id}) do
    specs = for {_id, spec} <- :ets.tab2list(table_id), do: spec
    {:reply, specs, state}
  end

  def handle_call({:get_spec, route_state_id}, _, state = %{route_spec_table_id: table_id}) do
    result =
      case :ets.lookup(table_id, route_state_id) do
        [{_id, spec}] -> spec
        [] -> nil
      end

    {:reply, result, state}
  end

  @impl GenServer
  def handle_cast(:update, state = %{env: env, route_spec_table_id: table_id}) do
    do_update_specs(env, table_id)
    {:no_reply, state}
  end

  defp do_update_specs(env, table_id) do
    RouteSpec.list_route_specs(env)
    |> write_specs(table_id)
  end

  defp write_specs(specs, table_id) do
    objects = for spec <- specs, do: {spec.route_state_id, spec}
    true = :ets.insert(table_id, objects)
  end

  defp bootstrap_route_spec_table() do
    :ets.new(@route_spec_table, [:set])
  end

  defp report_spec_not_found(route_state_id) do
    :telemetry.execute([:belfrage, :route_spec, :not_found], %{}, %{route_spec: route_state_id})
    Logger.log(:error, "", %{msg: "Route spec '#{route_state_id}' not found"})
    nil
  end
end
