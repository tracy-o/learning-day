defmodule Belfrage.RouteSpecManager do
  use GenServer

  alias Belfrage.RouteSpec

  @route_spec_table :route_spec_table

  def start_link(opts), do: GenServer.start_link(__MODULE__, opts, name: __MODULE__)

  @spec get_spec({RouteSpec.name(), RouteSpec.platform()}) :: map() | nil
  def get_spec({spec_name, platform}) do
    case do_get_spec(spec_name) do
      %{specs: specs} -> match_spec_by_platform(specs, platform)
      [] -> nil
    end
  end

  @spec get_spec(RouteSpec.name()) :: map() | nil
  def get_spec(spec_name) when is_binary(spec_name) do
    do_get_spec(spec_name)
  end

  @spec list_specs() :: [map()]
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
    objects = for spec <- specs, do: {spec.name, spec}
    true = :ets.delete_all_objects(@route_spec_table)
    true = :ets.insert(@route_spec_table, objects)
    :ok
  end

  defp bootstrap_route_spec_table(),
    do: :ets.new(@route_spec_table, [:set, :protected, :named_table, read_concurrency: true])

  defp do_get_spec(spec_name) do
    case :ets.lookup(@route_spec_table, spec_name) do
      [{_id, spec}] -> spec
      [] -> nil
    end
  end

  defp match_spec_by_platform(specs, platform) do
    found_specs = for spec <- specs, spec.platform == platform, do: spec

    case found_specs do
      [] -> nil
      [spec] -> spec
    end
  end
end
