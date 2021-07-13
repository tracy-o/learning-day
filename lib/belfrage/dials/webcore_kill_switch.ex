defmodule Belfrage.Dials.WebcoreKillSwitch do
  @moduledoc false

  @behaviour Belfrage.Dial

  @impl Belfrage.Dial
  def transform("active"), do: true

  @impl Belfrage.Dial
  def transform("inactive"), do: false
end
