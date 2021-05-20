defmodule Belfrage.Monitor do
  @callback record_event(Belfrage.Event.t()) :: :ok

  @dial Application.get_env(:belfrage, :dial)

  def record_loop(loop_state) do
    case @dial.state(:monitor_enabled) do
      true ->
        Belfrage.Nodes.monitor_nodes()
        |> Enum.each(&send_to_monitor_node(&1, loop_state))

      false ->
        {:ok, false}
    end
  end

  def record_event(event) do
    case @dial.state(:monitor_enabled) do
      true ->
        Belfrage.Nodes.monitor_nodes()
        |> Enum.each(fn node ->
          :erlang.send_nosuspend({:event_interface, node}, cast_msg({:event, event}))
        end)

      false ->
        {:ok, false}
    end
  end

  defp send_to_monitor_node(node, loop_state) do
    :erlang.send_nosuspend({:message_interface, node}, cast_msg({:store, message_content(loop_state)}))
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

  defp cast_msg(req), do: {:"$gen_cast", req}
end
