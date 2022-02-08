defmodule Belfrage.Dials.DatalabMachineRecommendations do
  @behaviour Belfrage.Dial

  @impl Belfrage.Dial
  def transform("enabled"), do: true

  @impl Belfrage.Dial
  def transform("disabled"), do: false
end
