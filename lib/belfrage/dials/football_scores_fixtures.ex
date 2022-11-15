defmodule Belfrage.Dials.FootballScoresFixtures do
  @moduledoc false

  @behaviour Belfrage.Dial

  @impl Belfrage.Dial
  def transform("mozart"), do: "mozart"

  @impl Belfrage.Dial
  def transform("webcore"), do: "webcore"
end
