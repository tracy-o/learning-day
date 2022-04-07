defmodule Belfrage.Transformers.MvtMapperTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  alias Belfrage.Transformers.MvtMapper
  alias Belfrage.Struct

  describe "when there are mvt headers" do
    test "the mvt map contains mvt keys and values" do
      {:ok, struct} =
        MvtMapper.call([], %Struct{
          request: %Belfrage.Struct.Request{
            raw_headers: %{"bbc-mvt-1" => "experiment;button_colour;red", "bbc-mvt-5" => "feature;sidebar;false"}
          }
        })

      assert %{"mvt-button_colour" => {1, "experiment;red"}, "mvt-sidebar" => {5, "feature;false"}} ==
               struct.private.mvt
    end
  end

  describe "when there are no mvt headers" do
    test "the mvt map is empty" do
      {:ok, struct} =
        MvtMapper.call([], %Struct{
          request: %Belfrage.Struct.Request{
            raw_headers: %{"a" => "header"}
          }
        })

      assert %{} == struct.private.mvt
    end
  end

  describe "for mvt_enabled dial state" do
    test "when dial is enabled, mvt map contains expected keys and values" do
      stub_dial(:mvt_enabled, "true")

      {:ok, struct} =
        MvtMapper.call([], %Struct{
          request: %Belfrage.Struct.Request{
            raw_headers: %{"bbc-mvt-1" => "experiment;button_colour;red", "bbc-mvt-5" => "feature;sidebar;false"}
          }
        })

      assert %{"mvt-button_colour" => {1, "experiment;red"}, "mvt-sidebar" => {5, "feature;false"}} ==
               struct.private.mvt
    end

    test "when dial is disabled, mvt map is empty" do
      stub_dial(:mvt_enabled, "false")

      {:ok, struct} =
        MvtMapper.call([], %Struct{
          request: %Belfrage.Struct.Request{
            raw_headers: %{"bbc-mvt-1" => "experiment;button_colour;red", "bbc-mvt-5" => "feature;sidebar;false"}
          }
        })

      assert %{} == struct.private.mvt
    end
  end
end
