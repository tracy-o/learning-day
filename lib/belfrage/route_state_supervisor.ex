defmodule Belfrage.RouteStateSupervisor do
  def start_link(opts) do
    DynamicSupervisor.start_link(
      name: Keyword.get(opts, :name, __MODULE__),
      strategy: :one_for_one
    )
  end

  def child_spec(opts) do
    %{
      id: Keyword.get(opts, :id, __MODULE__),
      start: {__MODULE__, :start_link, [opts]},
      type: :supervisor
    }
  end

  def start_route_state(supervisor \\ __MODULE__, name) do
    case start_child(supervisor, name) do
      {:ok, pid} -> pid
      {:error, {:already_started, pid}} -> pid
    end
  end

  defp start_child(supervisor, name) do
    DynamicSupervisor.start_child(
      supervisor,
      {Belfrage.RouteState, name}
    )
  end
end
