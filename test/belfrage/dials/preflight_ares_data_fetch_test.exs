defmodule Belfrage.Dials.PreflightAresDataFetchTest do
  use ExUnit.Case, async: true

  test "when dial on, returns 'on'" do
    assert Belfrage.Dials.PreflightAresDataFetch.transform("on") == "on"
  end

  test "when dial off returns 'off'" do
    assert Belfrage.Dials.PreflightAresDataFetch.transform("off") == "off"
  end

  test "when dial off returns 'learning'" do
    assert Belfrage.Dials.PreflightAresDataFetch.transform("learning") == "learning"
  end
end
