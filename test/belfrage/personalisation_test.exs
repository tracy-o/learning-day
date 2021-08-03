defmodule Belfrage.PersonalisationTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox
  import Belfrage.Test.PersonalisationHelper

  alias Belfrage.Personalisation
  alias Belfrage.Struct

  describe "transform_route_spec/1" do
    @route_spec %{
      owner: "An owner",
      runbook: "A run book",
      platform: Webcore,
      pipeline: ["a", "really", "long", "pipeline"]
    }

    test "adds personalisation attrs if personalisation is 'on'" do
      spec = Map.put(@route_spec, :personalisation, "on")
      result = Personalisation.transform_route_spec(spec)
      assert result.headers_allowlist == ["x-id-oidc-signedin"]
      assert result.cookie_allowlist == ["ckns_atkn", "ckns_id"]
      assert result.personalised_route
      assert Map.drop(result, ~w(personalised_route cookie_allowlist headers_allowlist)a) == spec
    end

    test "adds personalisation attrs if personalisation is 'test_only' and prod env is test" do
      assert Application.get_env(:belfrage, :production_environment) == "test"

      spec = Map.put(@route_spec, :personalisation, "test_only")
      result = Personalisation.transform_route_spec(spec)
      assert result.headers_allowlist == ["x-id-oidc-signedin"]
      assert result.cookie_allowlist == ["ckns_atkn", "ckns_id"]
      assert result.personalised_route
      assert Map.drop(result, ~w(personalised_route cookie_allowlist headers_allowlist)a) == spec
    end

    test "does not add personalisation attrs if personalisation is 'test_only' and prod env is not test" do
      original_env = Application.get_env(:belfrage, :production_environment)
      Application.put_env(:belfrage, :production_environment, "live")
      on_exit(fn -> Application.put_env(:belfrage, :production_environment, original_env) end)

      spec = Map.put(@route_spec, :personalisation, "test_only")
      result = Personalisation.transform_route_spec(spec)
      assert result == spec
    end

    test "does not add personalisation attrs if personalisation is some other value" do
      assert Personalisation.transform_route_spec(@route_spec) == @route_spec

      spec = Map.put(@route_spec, :personalisation, "off")
      assert Personalisation.transform_route_spec(spec) == spec
    end

    test "merges personalisation headers and cookies with existing ones" do
      spec =
        Map.merge(@route_spec, %{
          personalisation: "on",
          headers_allowlist: ["some_header"],
          cookie_allowlist: ["some_cookie"]
        })

      result = Personalisation.transform_route_spec(spec)
      assert result.headers_allowlist == ["some_header", "x-id-oidc-signedin"]
      assert result.cookie_allowlist == ["some_cookie", "ckns_atkn", "ckns_id"]
    end
  end

  describe "enabled?/0" do
    test "returns true when the dial is on and the flagpole is green" do
      stub_dial(:personalisation, "off")
      stub_flagpole(false)
      refute Personalisation.enabled?()

      stub_dial(:personalisation, "on")
      stub_flagpole(false)
      refute Personalisation.enabled?()

      stub_dial(:personalisation, "off")
      stub_flagpole(true)
      refute Personalisation.enabled?()

      stub_dial(:personalisation, "on")
      stub_flagpole(true)
      assert Personalisation.enabled?()
    end
  end

  describe "personalised_request?/1" do
    test "returns true if personalisation is enabled and request is made by authenticated user to personalised route on bbc.co.uk" do
      enable_personalisation()

      struct =
        %Struct{}
        |> set_host("bbc.co.uk")
        |> set_personalised_route(true)
        |> authenticate_request()

      assert Personalisation.personalised_request?(struct)

      refute struct |> deauthenticate_request() |> Personalisation.personalised_request?()
      refute struct |> set_personalised_route(false) |> Personalisation.personalised_request?()
      refute struct |> set_host("bbc.com") |> Personalisation.personalised_request?()

      disable_personalisation()
      refute Personalisation.personalised_request?(struct)
    end

    def set_host(struct, host) do
      Struct.add(struct, :request, %{host: host})
    end

    def set_personalised_route(struct, value) do
      Struct.add(struct, :private, %{personalised_route: value})
    end
  end

  defp stub_flagpole(value) do
    Mox.stub(Belfrage.Authentication.FlagpoleMock, :state, fn -> value end)
  end

  def enable_personalisation() do
    stub_dial(:personalisation, "on")
    stub_flagpole(true)
  end

  def disable_personalisation() do
    stub_dial(:personalisation, "off")
    stub_flagpole(false)
  end
end
