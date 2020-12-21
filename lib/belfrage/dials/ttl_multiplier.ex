defmodule Belfrage.Dials.TtlMultiplier do
  @moduledoc false

  @behaviour Belfrage.Dial.Client

  @impl Belfrage.Dial.Client
  def transform("private"), do: 0

  @impl Belfrage.Dial.Client
  def transform("default"), do: 1

  @impl Belfrage.Dial.Client
  def transform("long"), do: 3

  @impl Belfrage.Dial.Client
  def transform("super_long"), do: 10
end
