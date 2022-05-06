defmodule Belfrage.Transformers.MvtMapperTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Transformers.MvtMapper
  alias Belfrage.Struct
  alias Belfrage.Mvt

  defp mvt_dial(context) do
    dial_state = Map.get(context, :dial_state)
    stub_dial(:mvt_enabled, dial_state)
    :ok
  end

  defp set_slot(context) do
    slot = Map.get(context, :slot)
    Mvt.Slots.set(%{"1" => slot})

    on_exit(fn -> Mvt.Slots.set(%{}) end)
    :ok
  end

  defp set_all_slots(context) do
    slots = Map.get(context, :slots, %{})
    Mvt.Slots.set(slots)

    on_exit(fn -> Mvt.Slots.set(%{}) end)
    :ok
  end

  describe "when the mvt dial is turned off" do
    setup [:mvt_dial]

    @tag dial_state: "false"
    test "no mvt headers will ever be mapped" do
      {:ok, struct} =
        MvtMapper.call(
          [],
          build_struct(
            raw_headers: %{"bbc-mvt-1" => "experiment;button_colour;red", "bbc-mvt-3" => "feature;sidebar;false"}
          )
        )

      assert %{} == struct.private.mvt
    end
  end

  describe "when an mvt request header has a corresponding slot header" do
    setup [:mvt_dial, :set_slot]

    @tag dial_state: "true"
    @tag slot: [
           %{"header" => "bbc-mvt-1", "key" => "button_colour"},
           %{"header" => "bbc-mvt-3", "key" => "sidebar"}
         ]
    test "the header is mapped and added to the struct" do
      {:ok, struct} =
        MvtMapper.call(
          [],
          build_struct(
            raw_headers: %{"bbc-mvt-1" => "experiment;button_colour;red", "bbc-mvt-3" => "feature;sidebar;false"}
          )
        )

      assert struct.private.mvt == %{
               "mvt-button_colour" => {1, "experiment;red"},
               "mvt-sidebar" => {3, "feature;false"}
             }
    end
  end

  describe "when a mvt request header matches a slot header but not a slot key" do
    setup [:mvt_dial, :set_slot]

    @tag dial_state: "true"
    @tag slot: [%{"header" => "bbc-mvt-1", "key" => "you_wont_match_me"}]
    test "the header isn't added to the struct" do
      {:ok, struct} = MvtMapper.call([], build_struct(raw_headers: %{"bbc-mvt-1" => "experiment;button_colour;red"}))
      assert struct.private.mvt == %{}
    end
  end

  describe "when an mvt request header doesn't have a corresponding slot header" do
    setup [:mvt_dial, :set_slot]

    @tag dial_state: "true"
    @tag slot: []
    test "the header isn't added to the struct" do
      {:ok, struct} = MvtMapper.call([], build_struct(raw_headers: %{"bbc-mvt-1" => "experiment;button_colour;red"}))
      assert struct.private.mvt == %{}
    end
  end

  describe "when there is a slot header but no corresponding mvt request header" do
    setup [:mvt_dial, :set_slot]

    @tag dial_state: "true"
    @tag slot: [%{"header" => "bbc-mvt-1", "key" => "button_colour"}]
    test "the header isn't added to the struct" do
      {:ok, struct} = MvtMapper.call([], build_struct([]))
      assert struct.private.mvt == %{}
    end
  end

  describe "when all slots are empty" do
    setup [:mvt_dial, :set_all_slots]

    @tag dial_state: "true"
    @tag slots: %{}
    test "the header isn't added to the struct" do
      {:ok, struct} = MvtMapper.call([], build_struct(raw_headers: %{"bbc-mvt-1" => "experiment;button_colour;red"}))
      assert struct.private.mvt == %{}
    end
  end

  describe "when there are no mvt request headers" do
    test "the mvt map is empty" do
      {:ok, struct} = MvtMapper.call([], build_struct(raw_headers: %{"a" => "header"}))

      assert %{} == struct.private.mvt
    end
  end

  defp build_struct(opts) do
    raw_headers = Keyword.get(opts, :raw_headers, %{})
    platform = Keyword.get(opts, :platform, Webcore)

    %Struct{
      request: %Belfrage.Struct.Request{
        raw_headers: raw_headers
      },
      private: %Belfrage.Struct.Private{
        platform: platform
      }
    }
  end
end
