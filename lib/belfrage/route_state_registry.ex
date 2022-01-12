defmodule Belfrage.RouteStateRegistry do
  alias Belfrage.{Struct, RouteStateSupervisor}

  def start_link do
    Registry.start_link(keys: :unique, name: __MODULE__)
  end

  def find_or_start(%Struct{private: %Struct.Private{route_state_id: route_state_id}}) do
    case Registry.lookup(__MODULE__, {Belfrage.RouteState, route_state_id}) do
      [{pid, _}] -> pid
      [] -> RouteStateSupervisor.start_route_state(route_state_id)
    end
  end

  def find(route_state_id) do
    case Registry.lookup(__MODULE__, {Belfrage.RouteState, route_state_id}) do
      [{pid, _}] -> pid
      [] -> nil
    end
  end

  def via_tuple(key) do
    {:via, Registry, {__MODULE__, key}}
  end

  def child_spec(_) do
    Supervisor.child_spec(
      Registry,
      id: __MODULE__,
      start: {__MODULE__, :start_link, []}
    )
  end
end
