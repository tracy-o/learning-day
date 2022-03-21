defmodule Belfrage.PersonalisationTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox
  import Belfrage.Test.PersonalisationHelper

  alias Belfrage.Personalisation
  alias Belfrage.RouteSpec
  alias Belfrage.Struct

  describe "maybe_put_personalised_route/1" do
    @route_spec %RouteSpec{
      owner: "An owner",
      runbook: "A run book",
      platform: Webcore,
      pipeline: ["a", "really", "long", "pipeline"]
    }

    test "sets :personalised_route to true when personalisation is on" do
      spec = %Belfrage.RouteSpec{@route_spec | personalisation: "on"}
      assert Personalisation.maybe_put_personalised_route(spec) == %Belfrage.RouteSpec{spec | personalised_route: true}
    end

    test "does not set :personalised_route to true when personalisation is off" do
      spec = %Belfrage.RouteSpec{@route_spec | personalisation: "off"}
      assert Personalisation.maybe_put_personalised_route(spec) == spec
    end
  end

  describe "maybe_put_personalised_request/1" do
    test "sets :personalised_request to true when request is personalised" do
      enable_personalisation()

      struct =
        %Struct{}
        |> set_host("bbc.co.uk")
        |> set_personalised_route(true)
        |> authenticate_request()

      assert Personalisation.maybe_put_personalised_request(struct) ==
               Struct.add(struct, :private, %{personalised_request: true})
    end

    test "does not set :personalised_request to true when request is not personalised" do
      enable_personalisation()
      struct = set_host(%Struct{}, "bbc.co.uk")

      assert Personalisation.maybe_put_personalised_request(struct) == struct
    end
  end

  describe "append_allowlists/1" do
    test "does not append allowlists when personalisation is off and request is not from app" do
      struct = %Struct{request: %Struct.Request{app?: false}, private: %Struct.Private{personalised_route: false}}
      assert Personalisation.append_allowlists(struct) == struct
    end

    test "does not append allowlists when personalisation is off and request is from app" do
      struct = %Struct{request: %Struct.Request{app?: true}, private: %Struct.Private{personalised_route: false}}
      assert Personalisation.append_allowlists(struct) == struct
    end

    test "appends correct allowlists when personalisation is on and request is from app" do
      struct = %Struct{request: %Struct.Request{app?: true}, private: %Struct.Private{personalised_route: true}}

      assert Personalisation.append_allowlists(struct) ==
               Struct.add(struct, :private, %{headers_allowlist: ["authorization", "x-authentication-provider"]})
    end

    test "appends allowlists when personalisation is on and request is not from app" do
      struct = %Struct{private: %Struct.Private{personalised_route: true}}

      assert Personalisation.append_allowlists(struct) ==
               Struct.add(struct, :private, %{
                 cookie_allowlist: ["ckns_atkn", "ckns_id"],
                 headers_allowlist: ["x-id-oidc-signedin"]
               })
    end
  end

  describe "enabled?/1" do
    defmodule BBCIDAvailable do
      def available?(), do: true
    end

    defmodule BBCIDNotAvailable do
      def available?(), do: false
    end

    test "returns true when the dial is on and BBC ID is available" do
      stub_dial(:personalisation, "off")
      refute Personalisation.enabled?(bbc_id: BBCIDNotAvailable)

      stub_dial(:personalisation, "on")
      refute Personalisation.enabled?(bbc_id: BBCIDNotAvailable)

      stub_dial(:personalisation, "off")
      refute Personalisation.enabled?(bbc_id: BBCIDAvailable)

      stub_dial(:personalisation, "on")
      assert Personalisation.enabled?(bbc_id: BBCIDAvailable)
    end

    test "returns true when both the news article personalisation and personalisation dial is on" do
      stub_dials(news_articles_personalisation: "on", personalisation: "on")
      assert(Personalisation.enabled?(route_state_id: "HomePagePersonalised"))
    end

    test "returns true when both the news article personalisation and personalisation dial is on for PersonalisedContainerData routes" do
      stub_dials(news_articles_personalisation: "on", personalisation: "on")
      assert(Personalisation.enabled?(route_state_id: "PersonalisedContainerData"))
      assert(Personalisation.enabled?(route_state_id: "HomePagePersonalised"))
    end

    test "returns false when the news article personalisation is off and personalisation dial is on for PersonalisedContainerData routes" do
      stub_dials(news_articles_personalisation: "off", personalisation: "on")
      refute(Personalisation.enabled?(route_state_id: "PersonalisedContainerData"))
      assert(Personalisation.enabled?(route_state_id: "HomePagePersonalised"))
    end

    test "returns false when global personalisation dial is off for PersonalisedContainerData routes" do
      stub_dials(news_articles_personalisation: "on", personalisation: "off")
      refute(Personalisation.enabled?(route_state_id: "PersonalisedContainerData"))
      refute(Personalisation.enabled?(route_state_id: "HomePagePersonalised"))
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

    defp set_host(struct, host) do
      Struct.add(struct, :request, %{host: host})
    end

    defp set_personalised_route(struct, value) do
      Struct.add(struct, :private, %{personalised_route: value})
    end
  end
end
