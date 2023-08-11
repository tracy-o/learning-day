defmodule Belfrage.Dials.NiElectionFailoverTest do
  use ExUnit.Case, async: true

  test "when dial on, returns 'on'" do
    assert Belfrage.Dials.NiElectionFailover.transform("on") == "on"
  end

  test "when dial off returns 'off'" do
    assert Belfrage.Dials.NiElectionFailover.transform("off") == "off"
  end
end
