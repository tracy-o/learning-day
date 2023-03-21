defmodule Belfrage.Dials.ObitModeTest do
  use ExUnit.Case, async: true
  alias Belfrage.Dials.ObitMode

  test "transform/1 converts string representation of 'on' to boolean" do
    assert ObitMode.transform("on") === "on"
  end

  test "transform/1 converts string representation of 'off' to boolean" do
    assert ObitMode.transform("off") === "off"
  end
end
