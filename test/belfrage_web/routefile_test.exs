defmodule BelfrageWeb.RoutefileTest do
  use ExUnit.Case

  alias BelfrageWeb.Routefile

  describe "for_cosoms/1" do
    test "returns the routefile associated to Live cosmos env" do
      assert Routefile.for_cosmos("live") == Routes.Routefiles.Main.Live
    end

    test "returns the routefile associated to Test cosmos env" do
      assert Routefile.for_cosmos("test") == Routes.Routefiles.Main.Test
    end

    test "returns the Live routefile for any unexpected cosmos env" do
      assert Routefile.for_cosmos("foo") == Routes.Routefiles.Main.Live
    end
  end

  describe "module compilation" do
    test "mock Routefile module should be compiled when running tests" do
      assert {:module, Routes.Routefiles.Mock} == Code.ensure_compiled(Routes.Routefiles.Mock)
    end
  end
end
