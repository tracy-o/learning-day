defmodule Belfrage.PersonalisationTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox
  import Belfrage.Test.PersonalisationHelper

  alias Belfrage.Personalisation
  alias Belfrage.RouteSpec
  alias Belfrage.Envelope

  describe "maybe_put_personalised_route/1" do
    @route_spec %RouteSpec{
      owner: "An owner",
      runbook: "A run book",
      platform: "Webcore",
      request_pipeline: ["a", "really", "long", "pipeline"]
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

      envelope =
        %Envelope{}
        |> set_host("bbc.co.uk")
        |> set_personalised_route(true)
        |> authenticate_request()

      assert Personalisation.maybe_put_personalised_request(envelope) ==
               Envelope.add(envelope, :private, %{personalised_request: true})
    end

    test "does not set :personalised_request to true when request is not personalised" do
      enable_personalisation()
      envelope = set_host(%Envelope{}, "bbc.co.uk")

      assert Personalisation.maybe_put_personalised_request(envelope) == envelope
    end
  end

  describe "append_allowlists/1" do
    test "does not append allowlists when personalisation is off and request is not from app" do
      envelope = %Envelope{
        request: %Envelope.Request{app?: false},
        private: %Envelope.Private{personalised_route: false}
      }

      assert Personalisation.append_allowlists(envelope) == envelope
    end

    test "does not append allowlists when personalisation is off and request is from app" do
      envelope = %Envelope{
        request: %Envelope.Request{app?: true},
        private: %Envelope.Private{personalised_route: false}
      }

      assert Personalisation.append_allowlists(envelope) == envelope
    end

    test "appends correct allowlists when personalisation is on and request is from app" do
      envelope = %Envelope{request: %Envelope.Request{app?: true}, private: %Envelope.Private{personalised_route: true}}

      assert Personalisation.append_allowlists(envelope) ==
               Envelope.add(envelope, :private, %{headers_allowlist: ["authorization", "x-authentication-provider"]})
    end

    test "appends allowlists when personalisation is on and request is not from app" do
      envelope = %Envelope{private: %Envelope.Private{personalised_route: true}}

      assert Personalisation.append_allowlists(envelope) ==
               Envelope.add(envelope, :private, %{
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
      assert(Personalisation.enabled?(route_state_id: {"HomePage", "Webcore"}))
    end

    test "returns true when both the news article personalisation and personalisation dial is on for PersonalisedContainerData routes" do
      stub_dials(news_articles_personalisation: "on", personalisation: "on")
      assert(Personalisation.enabled?(route_state_id: {"PersonalisedContainerData", "Webcore"}))
      assert(Personalisation.enabled?(route_state_id: {"HomePage", "Webcore"}))
    end

    test "returns false when the news article personalisation is off and personalisation dial is on for PersonalisedContainerData routes" do
      stub_dials(news_articles_personalisation: "off", personalisation: "on")
      refute(Personalisation.enabled?(route_state_id: {"PersonalisedContainerData", "Webcore"}))
      assert(Personalisation.enabled?(route_state_id: {"HomePage", "Webcore"}))
    end

    test "returns false when global personalisation dial is off for PersonalisedContainerData routes" do
      stub_dials(news_articles_personalisation: "on", personalisation: "off")
      refute(Personalisation.enabled?(route_state_id: {"PersonalisedContainerData", "Webcore"}))
      refute(Personalisation.enabled?(route_state_id: {"HomePage", "Webcore"}))
    end
  end

  describe "personalised_request?/1" do
    test "returns true if personalisation is enabled and request is made by authenticated user to personalised route on bbc.co.uk" do
      enable_personalisation()

      envelope =
        %Envelope{}
        |> set_host("bbc.co.uk")
        |> set_personalised_route(true)
        |> authenticate_request()

      assert Personalisation.personalised_request?(envelope)

      refute envelope |> deauthenticate_request() |> Personalisation.personalised_request?()
      refute envelope |> set_personalised_route(false) |> Personalisation.personalised_request?()
      refute envelope |> set_host("bbc.com") |> Personalisation.personalised_request?()

      disable_personalisation()
      refute Personalisation.personalised_request?(envelope)
    end

    test "returns true if personalisation is enabled and request is made with auth header by app user to personalised route on bbc.co.uk" do
      enable_personalisation()

      envelope =
        %Envelope{}
        |> Envelope.add(:request, %{app?: true})
        |> set_host("bbc.co.uk")
        |> set_personalised_route(true)
        |> personalise_app_request("some-value")

      assert Personalisation.personalised_request?(envelope)

      refute envelope |> unpersonalise_app_request() |> Personalisation.personalised_request?()
      refute envelope |> set_personalised_route(false) |> Personalisation.personalised_request?()
      refute envelope |> set_host("bbc.com") |> Personalisation.personalised_request?()

      disable_personalisation()
      refute Personalisation.personalised_request?(envelope)
    end

    defp set_host(envelope, host) do
      Envelope.add(envelope, :request, %{host: host})
    end

    defp set_personalised_route(envelope, value) do
      Envelope.add(envelope, :private, %{personalised_route: value})
    end
  end
end
