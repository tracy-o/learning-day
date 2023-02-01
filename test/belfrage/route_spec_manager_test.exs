defmodule Belfrage.RouteSpecManagerTest do
  use ExUnit.Case
  import Test.Support.Helper
  alias Belfrage.{RouteSpecManager, RouteSpec}

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
end
