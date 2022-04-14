defmodule Belfrage.Dials.ElectionBannerCouncilTest do
  use ExUnit.Case, async: true
  alias Belfrage.Dials.ElectionBannerCouncilStory

  test "when dial on, returns 'on'" do
    assert ElectionBannerCouncilStory.transform("on") == "on"
  end

  test "when dial off returns 'off'" do
    assert ElectionBannerCouncilStory.transform("off") == "off"
  end
end
