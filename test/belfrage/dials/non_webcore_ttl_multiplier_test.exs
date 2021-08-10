defmodule Belfrage.Dials.NonWebcoreTtlMultiplierTest do
  use ExUnit.Case, async: true
  alias Belfrage.Dials.TtlMultiplier

  describe "transform/1" do
    test "when the value is very-short" do
      assert NonWebcoreTtlMultiplier.transform("very-short") == 0.5
    end

    test "when the value is short" do
      assert NonWebcoreTtlMultiplier.transform("short") == 0.75
    end

    test "when the value is default" do
      assert NonWebcoreTtlMultiplier.transform("default") == 1
    end

    test "when the value is long" do
      assert NonWebcoreTtlMultiplier.transform("long") == 2
    end

    test "when the value is very-long" do
      assert NonWebcoreTtlMultiplier.transform("very-long") == 4
    end
  end
end
