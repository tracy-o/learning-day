defmodule Belfrage.EventStub do
  alias Belfrage.Event

  @behaviour Event

  @impl Belfrage.Event
  defdelegate record(type, level, msg, opts), to: Event
end
