defmodule Belfrage.RouteSpec.PersonalisationTest do
  use ExUnit.Case
  alias Belfrage.RouteSpec.Personalisation

  setup do
    on_exit(fn -> Application.put_env(:belfrage, :production_environment, "test") end)

    %{
      route_spec: %{
        owner: "An owner",
        runbook: "A run book",
        platform: Webcore,
        pipeline: ["a", "really", "long", "pipeline"]
      }
    }
  end

  describe "when the production environment is live" do
    setup do
      Application.put_env(:belfrage, :production_environment, "live")
    end

    test "a routespec with personalisation: 'on' is interpolated correctly", %{route_spec: route_spec} do
      route_spec = Map.put(route_spec, :personalisation, "on")

      result = Personalisation.maybe_interpolate_personalisation(route_spec)

      assert result[:cookie_allowlist] == ["ckns_atkn", "ckns_id"]
      assert result[:headers_allowlist] == ["x-id-oidc-signedin"]
      assert Map.drop(result, ~w(cookie_allowlist headers_allowlist)a) == route_spec
    end

    test "a routespec with personalisation: 'off' is not interpolated", %{route_spec: route_spec} do
      route_spec = Map.put(route_spec, :personalisation, "off")

      result = Personalisation.maybe_interpolate_personalisation(route_spec)

      refute result[:cookie_allowlist]
      refute result[:headers_allowlist]
      assert result == route_spec
    end

    test "a routespec with personalisation: 'test_only' is not interpolated", %{route_spec: route_spec} do
      route_spec = Map.put(route_spec, :personalisation, "test_only")

      result = Personalisation.maybe_interpolate_personalisation(route_spec)

      refute result[:cookie_allowlist]
      refute result[:headers_allowlist]
      assert result == route_spec
    end
  end

  describe "when the production environment is test" do
    setup do
      Application.put_env(:belfrage, :production_environment, "test")
    end

    test "a routespec with personalisation: 'on' is interpolated correctly", %{route_spec: route_spec} do
      route_spec = Map.put(route_spec, :personalisation, "on")

      result = Personalisation.maybe_interpolate_personalisation(route_spec)

      assert result[:cookie_allowlist] == ["ckns_atkn", "ckns_id"]
      assert result[:headers_allowlist] == ["x-id-oidc-signedin"]
      assert Map.drop(result, ~w(cookie_allowlist headers_allowlist)a) == route_spec
    end

    test "a routespec with personalisation: 'off' is not interpolated", %{route_spec: route_spec} do
      route_spec = Map.put(route_spec, :personalisation, "off")

      result = Personalisation.maybe_interpolate_personalisation(route_spec)

      refute result[:cookie_allowlist]
      refute result[:headers_allowlist]
      assert result == route_spec
    end

    test "a routespec with personalisation: 'test_only' is interpolated correctly", %{route_spec: route_spec} do
      route_spec = Map.put(route_spec, :personalisation, "test_only")

      result = Personalisation.maybe_interpolate_personalisation(route_spec)

      assert result[:cookie_allowlist] == ["ckns_atkn", "ckns_id"]
      assert result[:headers_allowlist] == ["x-id-oidc-signedin"]
      assert Map.drop(result, ~w(cookie_allowlist headers_allowlist)a) == route_spec
    end
  end

  test "a routespec with already existing allowlists do not get overwritten", %{route_spec: route_spec} do
    route_spec =
      route_spec
      |> Map.put(:personalisation, "on")
      |> Map.put(:cookie_allowlist, ["cookie1", "cookie2"])
      |> Map.put(:headers_allowlist, ["header1"])

    result = Personalisation.maybe_interpolate_personalisation(route_spec)

    assert result[:cookie_allowlist] == ["cookie1", "cookie2", "ckns_atkn", "ckns_id"]
    assert result[:headers_allowlist] == ["header1", "x-id-oidc-signedin"]
  end
end
