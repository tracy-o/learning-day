defmodule Belfrage.Metrics.ProcessMessageQueueLength do
  alias Belfrage.{RouteStateRegistry, Metrics, RouteState}

  def track_route_state_message_queue_length(route_state_id) do
    with pid when not is_nil(pid) <- RouteStateRegistry.find(route_state_id),
         {:message_queue_len, message_queue_len} <- Process.info(pid, :message_queue_len) do
      Metrics.measurement(
        :route_state_message_queue_length,
        %{message_queue_len: message_queue_len},
        RouteState.map_id(route_state_id)
      )
    end
  end
end
