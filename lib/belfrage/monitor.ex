defmodule Belfrage.Monitor do
  def record_loop(loop_state) do
    with monitor_node when not is_nil(monitor_node) <- monitor_address() do
      GenServer.cast({:data_store, monitor_node}, {:store, loop_state})
    end
  end

  defp monitor_address do
    case Node.list() do
      [monitor] -> monitor
      _ -> nil
    end
  end
end
