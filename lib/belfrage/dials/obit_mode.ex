defmodule Belfrage.Dials.ObitMode do
  @moduledoc false

  @behaviour Belfrage.Dial

  @impl Belfrage.Dial
  def transform("on"), do: true

  @impl Belfrage.Dial
  def transform("off"), do: false
end
