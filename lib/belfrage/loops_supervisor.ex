defmodule Belfrage.LoopsSupervisor do
  def start_link() do
    DynamicSupervisor.start_link(
      name: __MODULE__,
      strategy: :one_for_one
    )
  end

  def child_spec(_arg) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :supervisor
    }
  end

  def start_loop(name) do
    case start_child(name) do
      {:ok, pid} ->
        pid

      {:error, {:already_started, pid}} ->
        pid

      {:error, {:undef, details}} ->
        raise """
        Seems like that route has not been registered, define it in routes/specs
        more details: #{inspect(details)}
        """
    end
  end

  def kill_all do
    DynamicSupervisor.which_children(__MODULE__)
    |> Enum.each(&kill_child/1)
  end

  defp kill_child({_, pid, _, _}) do
    Process.exit(pid, :stop)
  end

  defp start_child(name) do
    DynamicSupervisor.start_child(
      __MODULE__,
      {Belfrage.Loop, name}
    )
  end
end
