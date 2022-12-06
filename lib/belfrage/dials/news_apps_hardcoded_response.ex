defmodule Belfrage.Dials.NewsAppsHardcodedResponse do
  @behaviour Belfrage.Dial

  @impl Belfrage.Dial
  def transform("disabled"), do: "disabled"

  @impl Belfrage.Dial
  def transform("enabled"), do: "enabled"
end
