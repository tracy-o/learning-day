defmodule Belfrage.Dials.WebcoreTtlMultiplier do
  @moduledoc false

  @behaviour Belfrage.Dial

  @impl Belfrage.Dial
  def transform("0.5x"), do: 0.5

  @impl Belfrage.Dial
  def transform("0.8x"), do: 0.8

  @impl Belfrage.Dial
  def transform("1x"), do: 1

  @impl Belfrage.Dial
  def transform("2x"), do: 2

  @impl Belfrage.Dial
  def transform("4x"), do: 4
end
