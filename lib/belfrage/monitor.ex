defmodule Belfrage.Monitor do
  def record_loop(loop_state) do
    Node.list()
    |> Enum.each(&send_to_monitor_node(&1, loop_state))
  end

  defp send_to_monitor_node(node, loop_state) do
    GenServer.cast({:message_interface, node}, {:store, message_content(loop_state)})
  end

  defp message_content(loop_state) do
    {node(), "first-belfrage-stack", loop_state}
  end
end
