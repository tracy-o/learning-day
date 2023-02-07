defmodule Belfrage.RouteSpecManagerTest do
  use ExUnit.Case
  import Test.Support.Helper
  alias Belfrage.{RouteSpecManager, RouteSpec}

  test "creates a route spec table with expected contents" do
    assert Enum.all?(ets_table_contents(), fn {key, %Belfrage.RouteSpec{}} -> is_binary(key) end)
  end

  describe "get_spec" do
    test "retrieves expected spec if key is in ets table" do
      {key, route_spec} = Enum.random(ets_table_contents())
      assert RouteSpecManager.get_spec(key) == route_spec
    end

    test "retrieves no spec if key is not in ets table" do
      assert RouteSpecManager.get_spec("SomeRouteSpec") == nil
    end
  end

  describe "list_specs" do
    test "retrieves specs with expected values" do
      Enum.each(Belfrage.RouteSpecManager.list_specs(), fn spec ->
        assert %Belfrage.RouteSpec{} = spec
      end)
    end

    test "retrieves different specs per production environment" do
      Belfrage.RouteSpecManager.update_specs()
      test_specs = Belfrage.RouteSpecManager.list_specs()

      set_env(:belfrage, :production_environment, "live", &RouteSpecManager.update_specs/0)

      Belfrage.RouteSpecManager.update_specs()

      live_specs = Belfrage.RouteSpecManager.list_specs()

      refute live_specs == test_specs
    end
  end

  test "Ensure route spec table is correct on test" do
    RouteSpecManager.update_specs()

    fabldata_route_spec = RouteSpecManager.get_spec("FablData.Fabl")

    assert ["ctx-service-env"] == fabldata_route_spec.headers_allowlist
    assert ["Personalisation", "CircuitBreaker", "DevelopmentRequests"] == fabldata_route_spec.request_pipeline
    assert Enum.sort(RouteSpec.list_route_specs()) == Enum.sort(RouteSpecManager.list_specs())
  end

  test "Ensure route spec table is correct on live" do
    set_env(:belfrage, :production_environment, "live", &RouteSpecManager.update_specs/0)
    RouteSpecManager.update_specs()

    fabldata_route_spec = RouteSpecManager.get_spec("FablData.Fabl")

    assert [] == fabldata_route_spec.headers_allowlist
    assert ["Personalisation", "CircuitBreaker"] == fabldata_route_spec.request_pipeline
    assert Enum.sort(RouteSpec.list_route_specs()) == Enum.sort(RouteSpecManager.list_specs())
  end

  defp ets_table_contents() do
    :ets.tab2list(route_spec_table_id())
  end

  defp route_spec_table_id() do
    Belfrage.RouteSpecManager
    |> Process.whereis()
    |> :sys.get_state()
    |> Map.get(:route_spec_table_id)
  end
end
