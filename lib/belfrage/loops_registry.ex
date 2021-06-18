defmodule Belfrage.LoopsRegistry do
  alias Belfrage.{Struct, LoopsSupervisor}

  def start_link do
    Registry.start_link(keys: :unique, name: __MODULE__)
  end

  def find_or_start(%Struct{private: %Struct.Private{loop_id: loop_id}}) do
    case Registry.lookup(__MODULE__, loop_id) do
      [{pid, _}] -> pid
      [] -> LoopsSupervisor.start_loop(loop_id)
    end
  end

  def find(loop_id) do
    case Registry.lookup(__MODULE__, {Belfrage.Loop, loop_id}) do
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
