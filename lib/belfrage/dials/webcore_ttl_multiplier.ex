defmodule Belfrage.Dials.WebcoreTtlMultiplier do
  @moduledoc false

  @behaviour Belfrage.Dial

  @impl Belfrage.Dial
  def transform("very-short"), do: 1 / 3

  @impl Belfrage.Dial
  def transform("short"), do: 2 / 3

  @impl Belfrage.Dial
  def transform("default"), do: 1

  @impl Belfrage.Dial
  def transform("long"), do: 6

  @impl Belfrage.Dial
  def transform("very-long"), do: 12

  @impl Belfrage.Dial
  def transform("longest"), do: 24
end
