defmodule Belfrage.Dials.NewsAppsVarianceReducerTest do
  use ExUnit.Case, async: true

  test "when dial is enabled, returns 'enabled'" do
    assert Belfrage.Dials.NewsAppsVarianceReducer.transform("enabled") == "enabled"
  end

  test "when dial is disabled returns 'disabled'" do
    assert Belfrage.Dials.NewsAppsVarianceReducer.transform("disabled") == "disabled"
  end
end
