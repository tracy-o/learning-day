defmodule Belfrage.Dials.TtlMultiplierTest do
  use ExUnit.Case
  alias Belfrage.Dials.TtlMultiplier

  describe "transform/1" do
    test "when values is long" do
      assert TtlMultiplier.transform("long") == 3
    end

    test "when values is private" do
      assert TtlMultiplier.transform("private") == 0
    end

    test "when values is default" do
      assert TtlMultiplier.transform("default") == 1
    end

    test "when values is super_long" do
      assert TtlMultiplier.transform("super_long") == 10
    end
  end
end
