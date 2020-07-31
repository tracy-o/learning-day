defmodule Fixtures.Dials do
  def cosmos_dials_data() do
    Application.app_dir(:belfrage, "priv/static/dials.json")
    |> File.read!()
    |> Jason.decode!()
  end
end
