defmodule BelfrageWeb.RoutefilePointerTest do
  use ExUnit.Case

  alias BelfrageWeb.RoutefilePointer

  describe "on Mix.env :dev" do
    test "Cosmos test will return the Main Test Routefile" do
      assert RoutefilePointer.routefile_module(%{path_info: ["news"]}, "test", :dev) == Routes.Routefiles.Main.Test
    end
  end

  describe "on Mix.env :dev and Sport" do
    test "Cosmos test will return the Sport Test Routefile" do
      assert RoutefilePointer.routefile_module(%{path_info: ["sport"]}, "test", :dev) == Routes.Routefiles.Sport.Test
    end
  end

  describe "on Mix.env :dev and Sport with .app" do
    test "Cosmos test will return the Sport Test Routefile" do
      assert RoutefilePointer.routefile_module(%{path_info: ["sport.app"]}, "test", :dev) ==
               Routes.Routefiles.Sport.Test
    end
  end

  describe "on Mix.env :test" do
    test "Cosmos test will return the Mock Routefile" do
      assert RoutefilePointer.routefile_module(%{path_info: ["news"]}, "test", :test) == Routes.Routefiles.Mock
    end

    test "Cosmos live will return the Mock Routefile" do
      assert RoutefilePointer.routefile_module(%{path_info: ["news"]}, "live", :test) == Routes.Routefiles.Mock
    end
  end

  describe "on Mix.env :smoke_test" do
    test "Cosmos test will return the Main Test Routefile" do
      assert RoutefilePointer.routefile_module(%{path_info: ["news"]}, "test", :smoke_test) ==
               Routes.Routefiles.Main.Test
    end

    test "Cosmos live  will return the Main Test Routefile" do
      assert RoutefilePointer.routefile_module(%{path_info: ["news"]}, "live", :smoke_test) ==
               Routes.Routefiles.Main.Test
    end
  end

  describe "on Cosmos env test" do
    test "Cosmos test will return the Main Test Routefile" do
      assert RoutefilePointer.routefile_module(%{path_info: ["news"]}, "test", :live) == Routes.Routefiles.Main.Test
    end
  end

  describe "on Cosmos env live" do
    test "Cosmos live will return the Main Live Routefile" do
      assert RoutefilePointer.routefile_module(%{path_info: ["news"]}, "live", :live) == Routes.Routefiles.Main.Live
    end
  end

  describe "on Cosmos env live and Sport" do
    test "Cosmos live will return the Sport Live Routefile" do
      assert RoutefilePointer.routefile_module(%{path_info: ["sport"]}, "live", :live) == Routes.Routefiles.Sport.Live
    end
  end

  describe "on unexpected values" do
    test "will return the Main Live Routefile" do
      assert RoutefilePointer.routefile_module(%{path_info: ["news"]}, "foo", :bar) == Routes.Routefiles.Main.Live
    end
  end
end
