defmodule Belfrage.Dials.FootballScoresFixturesTest do
  use ExUnit.Case, async: true

  test "dial returns 'mozart' as default" do
    assert Belfrage.Dials.FootballScoresFixtures.transform("mozart") == "mozart"
  end

  test "dial can return 'webcore'" do
    assert Belfrage.Dials.FootballScoresFixtures.transform("webcore") == "webcore"
  end
end
