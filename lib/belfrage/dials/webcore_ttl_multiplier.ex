defmodule Belfrage.Dials.WebcoreTtlMultiplier do
  @moduledoc false

  @behaviour Belfrage.Dial

  @impl Belfrage.Dial
  def transform("half"), do: 0.5

  @impl Belfrage.Dial
  def transform("three-quarters"), do: 0.75

  @impl Belfrage.Dial
  def transform("one"), do: 1

  @impl Belfrage.Dial
  def transform("two"), do: 2

  @impl Belfrage.Dial
  def transform("four"), do: 4
end
