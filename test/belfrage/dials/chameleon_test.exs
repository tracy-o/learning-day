defmodule Belfrage.Dials.ChameleonTest do
  use ExUnit.Case, async: true
  alias Belfrage.Dials.Chameleon

  test "when dial on, returns 'on'" do
    assert Chameleon.transform("on") == "on"
  end

  test "when dial off returns 'off'" do
    assert Chameleon.transform("off") == "off"
  end
end
