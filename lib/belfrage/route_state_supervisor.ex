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
      type: :supervisor,
      restart: :temporary
    }
  end

  def start_route_state(supervisor \\ __MODULE__, id, args) do
    case start_child(supervisor, id, args) do
      {:ok, pid} -> pid
      {:error, {:already_started, pid}} -> pid
      {:error, _} = error -> error
    end
  end

  defp start_child(supervisor, id, args) do
    DynamicSupervisor.start_child(
      supervisor,
      {Belfrage.RouteState, {id, args}}
    )
  end
end
