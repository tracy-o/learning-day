defmodule Belfrage.MonitorStub do
  @behaviour Belfrage.Monitor

  def record_event(_event), do: :ok
end
