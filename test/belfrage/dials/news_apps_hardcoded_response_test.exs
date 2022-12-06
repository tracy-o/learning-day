defmodule Belfrage.Dials.NewsAppsHardcodedResponseTest do
  use ExUnit.Case, async: true

  test "when the dial is disabled, returns 'disabled'" do
    assert Belfrage.Dials.NewsAppsHardcodedResponse.transform("disabled") == "disabled"
  end

  test "when dial is enabled, returns 'enabled'" do
    assert Belfrage.Dials.NewsAppsHardcodedResponse.transform("enabled") == "enabled"
  end
end
