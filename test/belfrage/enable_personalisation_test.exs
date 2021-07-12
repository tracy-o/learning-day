defmodule Belfrage.EnablePersonalisationTest do
  use ExUnit.Case, aync: true
  alias Belfrage.EnablePersonalisation

  setup do
    %{
      route_spec: %{
        owner: "An owner",
        runbook: "A run book",
        platform: Webcore,
        pipeline: ["a", "really", "long", "pipeline"]
      }
    }
  end

  describe "when the production environment is test" do
    setup do
        Application.put_env(:belfrage, :production_environment, "test")
    end

    test "a routespec with personalisation: 'on' is interpolated correctly", %{route_spec: route_spec} do
      route_spec = Map.put(route_spec, :personalisation, "on")

      assert EnablePersonalisation.maybe_interpolate_personalisation(route_spec) == %{
               owner: "An owner",
               runbook: "A run book",
               platform: Webcore,
               pipeline: ["a", "really", "long", "pipeline"],
               personalisation: "on",
               cookie_allowlist: ["ckns_atkn", "ckns_id"],
               headers_allowlist: ["x-id-oidc-signedin"]
             }
    end

    test "a routespec with personalisation: 'off' is not interpolated", %{route_spec: route_spec} do
      route_spec = Map.put(route_spec, :personalisation, "off")

      assert EnablePersonalisation.maybe_interpolate_personalisation(route_spec) == %{
               owner: "An owner",
               runbook: "A run book",
               platform: Webcore,
               pipeline: ["a", "really", "long", "pipeline"],
               personalisation: "off"
             }
    end

    test "a routespec with personalisation: 'test_only' is interpolated correctly", %{route_spec: route_spec} do
      route_spec = Map.put(route_spec, :personalisation, "test_only")

      assert EnablePersonalisation.maybe_interpolate_personalisation(route_spec) == %{
               owner: "An owner",
               runbook: "A run book",
               platform: Webcore,
               pipeline: ["a", "really", "long", "pipeline"],
               personalisation: "test_only",
               cookie_allowlist: ["ckns_atkn", "ckns_id"],
               headers_allowlist: ["x-id-oidc-signedin"]
             }
    end
  end

  describe "when the production environment is live" do
    setup do
        Application.put_env(:belfrage, :production_environment, "live")
    end
    
    test "a routespec with personalisation: 'on' is interpolated correctly", %{route_spec: route_spec} do
      route_spec = Map.put(route_spec, :personalisation, "on")

      assert EnablePersonalisation.maybe_interpolate_personalisation(route_spec) == %{
               owner: "An owner",
               runbook: "A run book",
               platform: Webcore,
               pipeline: ["a", "really", "long", "pipeline"],
               personalisation: "on",
               cookie_allowlist: ["ckns_atkn", "ckns_id"],
               headers_allowlist: ["x-id-oidc-signedin"]
             }
    end

    test "a routespec with personalisation: 'off' is not interpolated", %{route_spec: route_spec} do
      route_spec = Map.put(route_spec, :personalisation, "off")

      assert EnablePersonalisation.maybe_interpolate_personalisation(route_spec) == %{
               owner: "An owner",
               runbook: "A run book",
               platform: Webcore,
               pipeline: ["a", "really", "long", "pipeline"],
               personalisation: "off"
             }
    end

    test "a routespec with personalisation: 'test_only' is not interpolated", %{route_spec: route_spec} do
      route_spec = Map.put(route_spec, :personalisation, "test_only")

      assert EnablePersonalisation.maybe_interpolate_personalisation(route_spec) == %{
               owner: "An owner",
               runbook: "A run book",
               platform: Webcore,
               pipeline: ["a", "really", "long", "pipeline"],
               personalisation: "test_only"
             }
    end
  end
end
