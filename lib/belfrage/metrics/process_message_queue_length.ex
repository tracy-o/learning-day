defmodule Belfrage.Metrics.ProcessMessageQueueLength do
  alias Belfrage.RouteStateRegistry
  alias Belfrage.Metrics

  def track_route_state_message_queue_length(route_state_name) do
    with pid when not is_nil(pid) <- RouteStateRegistry.find(route_state_name),
         {:message_queue_len, message_queue_len} <- Process.info(pid, :message_queue_len) do
      Metrics.measurement(:route_state_message_queue_length, %{message_queue_len: message_queue_len}, %{
        name: route_state_name
      })
    end
  end
end
