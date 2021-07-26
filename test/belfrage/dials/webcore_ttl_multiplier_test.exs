defmodule Belfrage.Dials.WebcoreTtlMultiplierTest do
  use ExUnit.Case, async: true
  alias Belfrage.Dials.WebcoreTtlMultiplier

  describe "transform/1" do
    test "when the value is half" do
      assert WebcoreTtlMultiplier.transform("half") == 0.5
    end

    test "when the value is three-quarters" do
      assert WebcoreTtlMultiplier.transform("three-quarters") == 0.75
    end

    test "when the value is one" do
      assert WebcoreTtlMultiplier.transform("one") == 1
    end

    test "when the value is two" do
      assert WebcoreTtlMultiplier.transform("two") == 2
    end

    test "when the value is four" do
      assert WebcoreTtlMultiplier.transform("four") == 4
    end
  end
end
