defmodule JoeFormatter do
  use GenServer

  def init(opts) do
    ExUnit.CLIFormatter.init(opts)
  end

  def handle_cast(args = {:suite_started, _load_us}, state) do
    {:noreply, state}
  end

  def handle_cast(anything, state) do
    {:noreply, state}
  end
end
