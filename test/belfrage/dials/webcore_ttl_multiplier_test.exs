defmodule Belfrage.Dials.WebcoreTtlMultiplierTest do
  use ExUnit.Case, async: true
  alias Belfrage.Dials.WebcoreTtlMultiplier

  describe "transform/1" do
    test "when the value is 0.5x" do
      assert WebcoreTtlMultiplier.transform("0.5x") == 0.5
    end

    test "when the value is 0.8x" do
      assert WebcoreTtlMultiplier.transform("0.8x") == 0.8
    end

    test "when the value is 1x" do
      assert WebcoreTtlMultiplier.transform("1x") == 1
    end

    test "when the value is 2x" do
      assert WebcoreTtlMultiplier.transform("2x") == 2
    end

    test "when the value is 4x" do
      assert WebcoreTtlMultiplier.transform("4x") == 4
    end
  end
end
