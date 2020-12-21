defmodule Belfrage.DialStub do
  @behaviour Belfrage.Dial

  @impl Belfrage.Dial
  def state(:ttl_multiplier), do: Belfrage.Dials.TtlMultiplier.transform("default")
end
