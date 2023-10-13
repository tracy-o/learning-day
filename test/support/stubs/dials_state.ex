defmodule Belfrage.Dials.StateStub do
  @behaviour Belfrage.Dials.State

  @impl true
  def get_dial(dial_name), do: Belfrage.Dials.State.get_dial(dial_name)
end
