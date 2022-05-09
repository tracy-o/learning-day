defmodule Belfrage.Transformers.MvtMapperTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Transformers.MvtMapper
  alias Belfrage.Struct
  alias Belfrage.Mvt

  describe "when the mvt dial is turned off" do
    setup do
      stub_dial(:mvt_enabled, "false") && :ok
    end

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
    setup do
      stub_dial(:mvt_enabled, "true")

      set_slot([
        %{"header" => "bbc-mvt-1", "key" => "button_colour"},
        %{"header" => "bbc-mvt-3", "key" => "sidebar"}
      ])
    end

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
    setup do
      stub_dial(:mvt_enabled, "true")
      set_slot([%{"header" => "bbc-mvt-1", "key" => "you_wont_match_me"}])
    end

    test "the header isn't added to the struct" do
      {:ok, struct} = MvtMapper.call([], build_struct(raw_headers: %{"bbc-mvt-1" => "experiment;button_colour;red"}))
      assert struct.private.mvt == %{}
    end
  end

  describe "when an mvt request header doesn't have a corresponding slot header" do
    setup do
      stub_dial(:mvt_enabled, "true")
      set_slot([])
    end

    @tag dial_state: "true"
    @tag slot: []
    test "the header isn't added to the struct" do
      {:ok, struct} = MvtMapper.call([], build_struct(raw_headers: %{"bbc-mvt-1" => "experiment;button_colour;red"}))
      assert struct.private.mvt == %{}
    end
  end

  describe "when there is a slot header but no corresponding mvt request header" do
    setup do
      stub_dial(:mvt_enabled, "true")
      set_slot([%{"header" => "bbc-mvt-1", "key" => "button_colour"}])
    end

    test "the header isn't added to the struct" do
      {:ok, struct} = MvtMapper.call([], build_struct([]))
      assert struct.private.mvt == %{}
    end
  end

  describe "when all slots are empty" do
    setup do
      stub_dial(:mvt_enabled, "true")
      Mvt.Slots.set(%{})
      :ok
    end

    test "the header isn't added to the struct" do
      {:ok, struct} = MvtMapper.call([], build_struct(raw_headers: %{"bbc-mvt-1" => "experiment;button_colour;red"}))
      assert struct.private.mvt == %{}
    end
  end

  describe "when there are no mvt request headers" do
    setup do
      stub_dial(:mvt_enabled, "true") && :ok
    end

    test "the mvt map is empty" do
      {:ok, struct} = MvtMapper.call([], build_struct(raw_headers: %{"a" => "header"}))

      assert %{} == struct.private.mvt
    end
  end

  defp set_slot(slot) do
    Mvt.Slots.set(%{"1" => slot})
    on_exit(fn -> Mvt.Slots.set(%{}) end)
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
