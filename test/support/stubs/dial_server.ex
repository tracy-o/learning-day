defmodule Belfrage.Dials.ServerStub do
  @behaviour Belfrage.Dials.Server

  @impl Belfrage.Dials.Server
  def state(:ttl_multiplier), do: Belfrage.Dials.TtlMultiplier.transform("default")

  @impl Belfrage.Dials.Server
  def state(:ccp_bypass), do: Belfrage.Dials.CcpBypass.transform("default")
end
