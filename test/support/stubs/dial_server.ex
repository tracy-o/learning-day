defmodule Belfrage.Dials.ServerStub do
  @behaviour Belfrage.Dials.Server

  @impl Belfrage.Dials.Server
  def state(:ttl_multiplier), do: Belfrage.Dials.TtlMultiplier.transform("default")
end
