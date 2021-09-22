defmodule Belfrage.Metrics.GlobalDimensions do
  def build() do
    ["BBCEnvironment:" <> Application.get_env(:belfrage, :production_environment)]
  end
end
