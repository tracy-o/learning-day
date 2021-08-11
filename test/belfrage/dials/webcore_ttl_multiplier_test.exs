defmodule Belfrage.Dials.WebcoreTtlMultiplierTest do
  use ExUnit.Case, async: true
  alias Belfrage.Dials.WebcoreTtlMultiplier

  describe "transform/1" do
    test "when the value is very-short" do
      assert WebcoreTtlMultiplier.transform("very-short") == 0.5
    end

    test "when the value is short" do
      assert WebcoreTtlMultiplier.transform("short") == 0.75
    end

    test "when the value is default" do
      assert WebcoreTtlMultiplier.transform("default") == 1
    end

    test "when the value is long" do
      assert WebcoreTtlMultiplier.transform("long") == 2
    end

    test "when the value is very-long" do
      assert WebcoreTtlMultiplier.transform("very-long") == 4
    end
  end
end
