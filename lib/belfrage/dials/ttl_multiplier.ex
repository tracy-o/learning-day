defmodule Belfrage.Dials.TtlMultiplier do
  @moduledoc false

  use Belfrage.Dial, dial: "ttl_multiplier"

  @impl Belfrage.Dial
  def transform("private"), do: 0

  @impl Belfrage.Dial
  def transform("default"), do: 1

  @impl Belfrage.Dial
  def transform("long"), do: 3

  @impl Belfrage.Dial
  def transform("super_long"), do: 10
end
