defmodule Belfrage.Dials.Personalisation do
  @moduledoc false

  @behaviour Belfrage.Dial

  @impl Belfrage.Dial
  def transform("on"), do: true

  def transform("off"), do: false
end
