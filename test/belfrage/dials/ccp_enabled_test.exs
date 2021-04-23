defmodule Belfrage.Dials.CcpEnabledTest do
  use ExUnit.Case, async: true
  alias Belfrage.Dials.CcpEnabled

  test "transform/1 converts string representation of 'true' to boolean" do
    assert CcpEnabled.transform("true") == true
  end

  test "transform/1 converts string representation of 'false' to boolean" do
    assert CcpEnabled.transform("false") == false
  end
end
