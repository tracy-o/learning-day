defmodule Belfrage.Monitor do
  def record_loop(loop_state) do
    Node.list()
    |> Enum.each(&send_to_monitor_node(&1, loop_state))
  end

  defp send_to_monitor_node(node, loop_state) do
    GenServer.cast({:message_interface, node}, {:store, message_content(loop_state)})
  end

  defp message_content(loop_state) do
    {recorded_at(), node(), get_stack_name(), loop_state}
  end

  defp recorded_at do
    :os.system_time(:millisecond)
  end

  defp get_stack_name() do
    Application.get_env(:belfrage, :stack_name)
  end
end
