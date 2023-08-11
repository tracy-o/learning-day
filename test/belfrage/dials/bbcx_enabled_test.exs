defmodule Belfrage.Dials.BBCXEnabledTest do
  use ExUnit.Case, async: true

  test "when dial on, returns true" do
    assert Belfrage.Dials.BBCXEnabled.transform("true") == true
  end

  test "when dial off returns false" do
    assert Belfrage.Dials.BBCXEnabled.transform("false") == false
  end
end
