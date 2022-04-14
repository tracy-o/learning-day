defmodule Belfrage.Dials.ElectionBannerNiStoryTest do
  use ExUnit.Case, async: true
  alias Belfrage.Dials.ElectionBannerNiStory

  test "when dial on, returns 'on'" do
    assert ElectionBannerNiStory.transform("on") == "on"
  end

  test "when dial off returns 'off'" do
    assert ElectionBannerNiStory.transform("off") == "off"
  end
end
