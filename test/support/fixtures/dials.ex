defmodule Fixtures.Dials do
  def cosmos_dials_data() do
    Application.app_dir(:belfrage, "priv/static/dials.json")
    |> File.read!()
    |> Jason.decode!()
  end

  def other_dial_state(dial, current_value) do
    cosmos_dials_data()
    |> Enum.find(&(&1["name"] == dial))
    |> Map.get("values")
    |> Enum.find(&(&1["value"] != current_value))
    |> Map.get("value")
  end
end
