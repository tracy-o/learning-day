defmodule Belfrage.Dials.ServerStub do
  @behaviour Belfrage.Dials.Server

  @impl Belfrage.Dials.Server
  def state(:ttl_multiplier), do: Belfrage.Dials.TtlMultiplier.transform("default")

  @impl Belfrage.Dials.Server
  def state(:ccp_enabled), do: Belfrage.Dials.CcpEnabled.transform("true")

  @impl Belfrage.Dials.Server
  def state(:monitor_enabled), do: Belfrage.Dials.MonitorEnabled.transform("true")
end
