defmodule Belfrage.Metrics.CrashTracker do
  @moduledoc """
  This is a `Logger` backend that listens to log messages that are generated
  when a process crashes and records those crashes as a metric for monitoring
  purposes.
  """

  @behaviour :gen_event

  @event Application.get_env(:belfrage, :event)

  @impl true
  def init(opts), do: {:ok, opts}

  @impl true
  def handle_event({:error, group_leader, {_logger, _message, _timestamp, metadata}}, state)
      when node(group_leader) == node() do
    if Keyword.has_key?(metadata, :crash_reason) do
      @event.record(:metric, :increment, "error.process.crash")
    end

    {:ok, state}
  end

  @impl true
  def handle_event(_, state) do
    {:ok, state}
  end

  @impl true
  def handle_call(_, state) do
    {:ok, :ok, state}
  end
end
