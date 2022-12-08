defmodule Belfrage.Dials.NewsAppsVarianceReducer do
  @behaviour Belfrage.Dial

  @impl Belfrage.Dial
  def transform("enabled"), do: "enabled"

  @impl Belfrage.Dial
  def transform("disabled"), do: "disabled"
end
