defmodule BelfrageWeb.RoutefilePointerTest do
  use ExUnit.Case

  alias BelfrageWeb.RoutefilePointer

  describe "on Mix.env :dev" do
    test "Cosmos test will return the Test Routefile" do
      assert RoutefilePointer.routefile("test", :dev) == Routes.Routefiles.Test
    end
  end

  describe "on Mix.env :test" do
    test "Cosmos test will return the Mock Routefile" do
      assert RoutefilePointer.routefile("test", :test) == Routes.Routefiles.Mock
    end

    test "Cosmos live will return the Mock Routefile" do
      assert RoutefilePointer.routefile("live", :test) == Routes.Routefiles.Mock
    end
  end

  describe "on Mix.env :routes_test" do
    test "Cosmos test will return the Test Routefile" do
      assert RoutefilePointer.routefile("test", :routes_test) == Routes.Routefiles.Test
    end

    test "Cosmos live will return the Test Routefile" do
      assert RoutefilePointer.routefile("live", :routes_test) == Routes.Routefiles.Test
    end
  end

  describe "on Mix.env :smoke_test" do
    test "Cosmos test will return the Test Routefile" do
      assert RoutefilePointer.routefile("test", :smoke_test) == Routes.Routefiles.Test
    end

    test "Cosmos live  will return the Test Routefile" do
      assert RoutefilePointer.routefile("live", :smoke_test) == Routes.Routefiles.Test
    end
  end

  describe "on Cosmos env test" do
    test "Cosmos test will return the Test Routefile" do
      assert RoutefilePointer.routefile("test", :live) == Routes.Routefiles.Test
    end
  end

  describe "on Cosmos env live" do
    test "Cosmos live will return the Live Routefile" do
      assert RoutefilePointer.routefile("live", :live) == Routes.Routefiles.Live
    end
  end

  describe "on unexpected values" do
    test "will return the Live Routefile" do
      assert RoutefilePointer.routefile("foo", :bar) == Routes.Routefiles.Live
    end
  end
end
