defmodule Belfrage.Dials.Personalisation do
  @moduledoc false

  @behaviour Belfrage.Dial.Client

  @impl Belfrage.Dial.Client
  def transform("on"), do: true

  def transform("off"), do: false
end
