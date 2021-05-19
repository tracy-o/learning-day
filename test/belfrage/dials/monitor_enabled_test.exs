defmodule Belfrage.Dials.MonitorEnabledTest do
  use ExUnit.Case, async: true
  alias Belfrage.Dials.MonitorEnabled

  test "transform/1 converts string representation of 'true' to boolean" do
    assert MonitorEnabled.transform("true") == true
  end

  test "transform/1 converts string representation of 'false' to boolean" do
    assert MonitorEnabled.transform("false") == false
  end
end
