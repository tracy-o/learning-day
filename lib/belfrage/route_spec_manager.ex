defmodule Belfrage.RouteSpecManager do
  use GenServer

  alias Belfrage.RouteSpec

  @route_spec_table :route_spec_table

  def start_link(opts), do: GenServer.start_link(__MODULE__, opts, name: __MODULE__)

  @spec get_spec({RouteSpec.name(), RouteSpec.platform()}) :: RouteSpec.t() | nil
  def get_spec({spec, platform}) do
    case :ets.lookup(@route_spec_table, {spec, platform}) do
      [{_id, spec}] -> spec
      [] -> nil
    end
  end

  @spec list_specs() :: [RouteSpec.t()]
  def list_specs() do
    for {_id, spec} <- :ets.tab2list(@route_spec_table), do: spec
  end

  @spec update_specs() :: :ok
  def update_specs(), do: GenServer.call(__MODULE__, :update)

  # callbacks
  @impl GenServer
  def init(_) do
    bootstrap_route_spec_table()
    do_update_specs()
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call(:update, _from, state) do
    {:reply, do_update_specs(), state}
  end

  defp do_update_specs(), do: RouteSpec.list_route_specs() |> write_specs()

  defp write_specs(specs) do
    objects = for spec <- specs, do: {{spec.name, spec.platform}, spec}
    true = :ets.delete_all_objects(@route_spec_table)
    true = :ets.insert(@route_spec_table, objects)
    :ok
  end

  defp bootstrap_route_spec_table(),
    do: :ets.new(@route_spec_table, [:set, :protected, :named_table, read_concurrency: true])
end
