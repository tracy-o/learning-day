defmodule Ingress.LoopsRegistry do
  alias Ingress.LoopsSupervisor

  def start_link do
    Registry.start_link(keys: :unique, name: __MODULE__)
  end

  def find_or_start(name) do
    case Registry.lookup(__MODULE__, name) do
      [{pid, _}] -> pid
      [] -> LoopsSupervisor.start_loop(name)
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
