defmodule Belfrage.Mvt.MapperTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox
  import Test.Support.Helper, only: [set_slots: 1]
  alias Belfrage.Envelope
  alias Belfrage.Mvt

  setup :clear_slots_agent_state

  describe "when the mvt dial is turned off" do
    setup do
      stub_dial(:mvt_enabled, "false")
      :ok
    end

    test "no mvt headers will ever be mapped" do
      envelope =
        build_envelope(
          raw_headers: %{"bbc-mvt-1" => "experiment;button_colour;red", "bbc-mvt-3" => "feature;sidebar;false"}
        )
        |> Mvt.Mapper.map()

      assert %{} == envelope.private.mvt
    end
  end

  describe "when an mvt request header has a corresponding project slot" do
    setup do
      stub_dial(:mvt_enabled, "true")
      set_slots(%{"bbc-mvt-1" => "button_colour", "bbc-mvt-3" => "sidebar"})
      :ok
    end

    test "the header is mapped and added to the envelope" do
      envelope =
        build_envelope(
          raw_headers: %{"bbc-mvt-1" => "experiment;button_colour;red", "bbc-mvt-3" => "feature;sidebar;false"}
        )
        |> Mvt.Mapper.map()

      assert envelope.private.mvt == %{
               "mvt-button_colour" => {1, "experiment;red"},
               "mvt-sidebar" => {3, "feature;false"}
             }
    end
  end

  describe "when a mvt request header matches a slot header but not a slot key" do
    setup do
      stub_dial(:mvt_enabled, "true")
      set_slots(%{"bbc-mvt-1" => "box_colour_change"})
      :ok
    end

    test "the slot key is added to the envelope with a nil \"type;value\"" do
      envelope = build_envelope(raw_headers: %{"bbc-mvt-1" => "experiment;button_colour;red"}) |> Mvt.Mapper.map()

      assert envelope.private.mvt == %{"mvt-box_colour_change" => {1, nil}}
    end
  end

  describe "when an mvt request header doesn't have a corresponding slot experiment" do
    setup do
      stub_dial(:mvt_enabled, "true")
      :ok
    end

    test "the header isn't added to the envelope" do
      envelope =
        build_envelope(raw_headers: %{"bbc-mvt-1" => "experiment;button_colour;red"})
        |> Mvt.Mapper.map()

      assert envelope.private.mvt == %{}
    end
  end

  describe "when there is a slot in the project but no corresponding mvt request header" do
    setup do
      stub_dial(:mvt_enabled, "true")
      set_slots(%{"bbc-mvt-1" => "button_colour"})
      :ok
    end

    test "the header is added to the envelope with a nil \"type;value\"" do
      envelope = build_envelope([]) |> Mvt.Mapper.map()
      assert envelope.private.mvt == %{"mvt-button_colour" => {1, nil}}
    end
  end

  describe "when all slots are empty" do
    setup do
      stub_dial(:mvt_enabled, "true")
      :ok
    end

    test "the header isn't added to the envelope" do
      envelope = build_envelope(raw_headers: %{"bbc-mvt-1" => "experiment;button_colour;red"}) |> Mvt.Mapper.map()
      assert envelope.private.mvt == %{}
    end
  end

  describe "when there are no mvt request headers" do
    setup do
      stub_dial(:mvt_enabled, "true")
      :ok
    end

    test "the mvt map is empty" do
      envelope = build_envelope(raw_headers: %{"a" => "header"}) |> Mvt.Mapper.map()

      assert %{} == envelope.private.mvt
    end
  end

  describe "when a header has the key 'mvt-*' and the environment is 'test'" do
    # we will assume the environment is test here as `Belfrage.Mvt.Allowlist`
    # should filter out override headers when not on test.

    test "apply override header mapping" do
      envelope = build_envelope(raw_headers: %{"mvt-some_experiment" => "experiment;some_value"}) |> Mvt.Mapper.map()

      assert %{"mvt-some_experiment" => {:override, "experiment;some_value"}} == envelope.private.mvt
    end
  end

  describe "when 'bbc-mvt-complete' header is present" do
    test "it should be put in private.mvt with a slot of nil and data of '1' or '0'" do
      envelope = build_envelope(raw_headers: %{"bbc-mvt-complete" => "1"}) |> Mvt.Mapper.map()

      assert %{"bbc-mvt-complete" => {nil, "1"}} == envelope.private.mvt

      envelope = build_envelope(raw_headers: %{"bbc-mvt-complete" => "0"}) |> Mvt.Mapper.map()

      assert %{"bbc-mvt-complete" => {nil, "0"}} == envelope.private.mvt
    end
  end

  defp build_envelope(opts) do
    raw_headers = Keyword.get(opts, :raw_headers, %{})
    platform = Keyword.get(opts, :platform, "Webcore")

    %Envelope{
      request: %Belfrage.Envelope.Request{
        raw_headers: raw_headers
      },
      private: %Belfrage.Envelope.Private{
        platform: platform
      }
    }
  end

  defp clear_slots_agent_state(_context) do
    Mvt.Slots.set(%{})
    :ok
  end
end
