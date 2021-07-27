defmodule Belfrage.PersonalisationTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox
  import Belfrage.Test.PersonalisationHelper

  alias Belfrage.Personalisation
  alias Belfrage.Struct

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
    defmodule Module.concat([Routes, Specs, PersonalisedLoop]) do
      def specs do
        %{
          platform: Webcore,
          personalisation: "on"
        }
      end
    end

    defmodule Module.concat([Routes, Specs, NonPersonalisedLoop]) do
      def specs do
        %{
          platform: Webcore
        }
      end
    end

    test "returns true if personalisation is enabled and request is made by authenticated user to personalised route on bbc.co.uk" do
      enable_personalisation()

      struct =
        %Struct{}
        |> set_host("bbc.co.uk")
        |> set_loop(PersonalisedLoop)
        |> authenticate_request()

      assert Personalisation.personalised_request?(struct)

      refute struct |> deauthenticate_request() |> Personalisation.personalised_request?()
      refute struct |> set_loop(NonPersonalisedLoop) |> Personalisation.personalised_request?()
      refute struct |> set_host("bbc.com") |> Personalisation.personalised_request?()

      disable_personalisation()
      refute Personalisation.personalised_request?(struct)
    end

    def set_host(struct, host) do
      Struct.add(struct, :request, %{host: host})
    end

    def set_loop(struct, loop) do
      Struct.add(struct, :private, %{loop_id: loop})
    end
  end

  defp stub_dial(name, value) do
    value =
      Application.get_env(:belfrage, :dial_handlers)
      |> Map.fetch!(to_string(name))
      |> apply(:transform, [value])

    Mox.stub(Belfrage.Dials.ServerMock, :state, fn ^name -> value end)
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
