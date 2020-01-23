defmodule BelfrageWeb.ProductionEnvironmentTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.ProductionEnvironment

  describe "call" do
    test "puts the production_environment in the private part of the struct" do
      conn = conn("get", "/", "")
      assert ProductionEnvironment.call(conn, []).private[:production_environment] == "test"
    end
  end
end
