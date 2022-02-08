defmodule Belfrage.Dials.NonWebcoreTtlMultiplier do
  @moduledoc false

  @behaviour Belfrage.Dial

  @impl Belfrage.Dial
  def transform("very-short"), do: 0.5

  @impl Belfrage.Dial
  def transform("short"), do: 0.75

  @impl Belfrage.Dial
  def transform("default"), do: 1

  @impl Belfrage.Dial
  def transform("long"), do: 2

  @impl Belfrage.Dial
  def transform("very-long"), do: 4

  @impl Belfrage.Dial
  def transform("longest"), do: 6
end
