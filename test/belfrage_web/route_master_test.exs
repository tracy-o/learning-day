defmodule BelfrageWeb.RouteMasterTest do
  use ExUnit.Case
  use Plug.Test

  describe "calling handle when using the only_on option" do
    test "when the environments dont match, it will return a 404" do


    end

    test "when the environments match, it will continue with the request" do
      # mock the environment to be the same for this test
    end
  end
end
