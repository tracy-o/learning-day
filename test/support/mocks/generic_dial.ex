defmodule Belfrage.Dials.GenericDial do
  @behaviour Belfrage.Dial
  use Belfrage.Dial, dial: "a-generic-dial"

  @impl Belfrage.Dial
  def transform("true"), do: true

  @impl Belfrage.Dial
  def transform("false"), do: false
end
