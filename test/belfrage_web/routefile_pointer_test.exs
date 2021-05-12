defmodule BelfrageWeb.RoutefilePointerTest do
  use ExUnit.Case

  alias BelfrageWeb.RoutefilePointer

  describe "on Mix.env :dev" do
    test "Cosmos test will return the Sandbox Routefile" do
      assert RoutefilePointer.routefile("sandbox", :dev) == Routes.Routefiles.Sandbox
    end
  end

  describe "on Mix.env :test" do
    test "Cosmos sandbox will return the Mock Routefile" do
      assert RoutefilePointer.routefile("test", :test) == Routes.Routefiles.Mock
    end

    test "Cosmos test will return the Mock Routefile" do
      assert RoutefilePointer.routefile("test", :test) == Routes.Routefiles.Mock
    end

    test "Cosmos live will return the Mock Routefile" do
      assert RoutefilePointer.routefile("live", :test) == Routes.Routefiles.Mock
    end
  end

  describe "on Mix.env :routes_test" do
    test "Cosmos sandbox will return the Test Routefile" do
      assert RoutefilePointer.routefile("sandbox", :routes_test) == Routes.Routefiles.Test
    end

    test "Cosmos test will return the Test Routefile" do
      assert RoutefilePointer.routefile("test", :routes_test) == Routes.Routefiles.Test
    end

    test "Cosmos live will return the Test Routefile" do
      assert RoutefilePointer.routefile("live", :routes_test) == Routes.Routefiles.Test
    end
  end

  describe "on Mix.env :end_to_end" do
    test "Cosmos sandbox will return the Mock Routefile" do
      assert RoutefilePointer.routefile("sandbox", :end_to_end) == Routes.Routefiles.Mock
    end

    test "Cosmos test will return the Mock Routefile" do
      assert RoutefilePointer.routefile("test", :end_to_end) == Routes.Routefiles.Mock
    end

    test "Cosmos live will return the Mock Routefile" do
      assert RoutefilePointer.routefile("live", :end_to_end) == Routes.Routefiles.Mock
    end
  end

  describe "on Mix.env :smoke_test" do
    test "Cosmos sandbox will return the Test Routefile" do
      assert RoutefilePointer.routefile("sandbox", :smoke_test) == Routes.Routefiles.Test
    end

    test "Cosmos test will return the Test Routefile" do
      assert RoutefilePointer.routefile("test", :smoke_test) == Routes.Routefiles.Test
    end

      assert RoutefilePointer.routefile("live", :smoke_test) == Routes.Routefiles.Test
    test "Cosmos test will return the Live Routefile" do
    end
  end

  describe "on Cosmos env test" do
    test "Cosmos test will return the Test Routefile" do
      assert RoutefilePointer.routefile("test", :live) == Routes.Routefiles.Test
    end
  end

  describe "on Cosmos env live" do
    test "Cosmos test will return the Live Routefile" do
      assert RoutefilePointer.routefile("live", :live) == Routes.Routefiles.Live
    end
  end

  describe "on unexpected values" do
    test "will return the Live Routefile" do
      assert RoutefilePointer.routefile("foo", :bar) == Routes.Routefiles.Live
    end
  end
end
