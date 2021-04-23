defmodule Belfrage.Dials.CcpBypassTest do
  use ExUnit.Case, async: true
  alias Belfrage.Dials.CcpBypass

  test "transform/1 converts string representation of 'on' to boolean" do
    assert CcpBypass.transform("on") == true
  end

  test "transform/1 converts string representation of 'off' to boolean" do
    assert CcpBypass.transform("off") == false
  end
end
