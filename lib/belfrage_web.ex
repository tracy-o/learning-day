defmodule BelfrageWeb do
  # Namespace for anything web related.

  def routefile(_section) do
    env = Application.get_env(:belfrage, :production_environment) |> String.capitalize
    Module.concat(["Routes", "Routefiles", env])
  end
end
