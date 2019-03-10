defmodule Ingress.HandlersSupervisor do
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

  def start_handler(name) do
    case start_child(name) do
      {:ok, pid} -> pid
      {:error, {:already_started, pid}} -> pid
    end
  end

  defp start_child(name) do
    DynamicSupervisor.start_child(
      __MODULE__,
      {Ingress.Guardian, name}
    )
  end
end
