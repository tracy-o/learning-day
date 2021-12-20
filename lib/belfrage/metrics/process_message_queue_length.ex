defmodule Belfrage.Metrics.ProcessMessageQueueLength do
  alias Belfrage.RouteStateRegistry
  alias Belfrage.Metrics

  def track_loop_message_queue_length(loop_name) do
    with pid when not is_nil(pid) <- RouteStateRegistry.find(loop_name),
         {:message_queue_len, message_queue_len} <- Process.info(pid, :message_queue_len) do
      Metrics.measurement(:loop_message_queue_length, %{message_queue_len: message_queue_len}, %{name: loop_name})
    end
  end
end
