defmodule Belfrage.Dials.ServerStub do
  @behaviour Belfrage.Dials.Server

  @impl Belfrage.Dials.Server
  def state(:ttl_multiplier), do: Belfrage.Dials.TtlMultiplier.transform("default")

  @impl Belfrage.Dials.Server
  def state(:ccp_enabled), do: Belfrage.Dials.CcpEnabled.transform("true")

  @impl Belfrage.Dials.Server
  def state(:monitor_enabled), do: Belfrage.Dials.MonitorEnabled.transform("true")

  @impl Belfrage.Dials.Server
  def state(:webcore_kill_switch), do: Belfrage.Dials.WebcoreKillSwitch.transform("inactive")
end
