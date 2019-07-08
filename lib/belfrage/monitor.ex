defmodule Belfrage.Monitor do
  def record_loop(loop_state) do
    Node.list()
    |> Enum.each(&send_to_monitor_node(&1, loop_state))
  end

  defp send_to_monitor_node(node, loop_state) do
    GenServer.cast({:data_store, node}, {:store, loop_state})
  end
end
