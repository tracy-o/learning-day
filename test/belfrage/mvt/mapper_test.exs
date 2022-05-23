defmodule Belfrage.Mvt.MapperTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Struct
  alias Belfrage.Mvt

  describe "when the mvt dial is turned off" do
    setup do
      stub_dial(:mvt_enabled, "false")
      :ok
    end

    test "no mvt headers will ever be mapped" do
      struct =
        build_struct(
          raw_headers: %{"bbc-mvt-1" => "experiment;button_colour;red", "bbc-mvt-3" => "feature;sidebar;false"}
        )
        |> Mvt.Mapper.map()

      assert %{} == struct.private.mvt
    end
  end

  describe "when an mvt request header has a corresponding project slot" do
    setup do
      stub_dial(:mvt_enabled, "true")

      set_slots([
        %{"header" => "bbc-mvt-1", "key" => "button_colour"},
        %{"header" => "bbc-mvt-3", "key" => "sidebar"}
      ])
    end

    test "the header is mapped and added to the struct" do
      struct =
        build_struct(
          raw_headers: %{"bbc-mvt-1" => "experiment;button_colour;red", "bbc-mvt-3" => "feature;sidebar;false"}
        )
        |> Mvt.Mapper.map()

      assert struct.private.mvt == %{
               "mvt-button_colour" => {1, "experiment;red"},
               "mvt-sidebar" => {3, "feature;false"}
             }
    end
  end

  describe "when a mvt request header matches a slot header but not a slot key" do
    setup do
      stub_dial(:mvt_enabled, "true")
      set_slots([%{"header" => "bbc-mvt-1", "key" => "you_wont_match_me"}])
    end

    test "the header isn't added to the struct" do
      struct = build_struct(raw_headers: %{"bbc-mvt-1" => "experiment;button_colour;red"}) |> Mvt.Mapper.map()

      assert struct.private.mvt == %{}
    end
  end

  describe "when an mvt request header doesn't have a corresponding slot experiment" do
    setup do
      stub_dial(:mvt_enabled, "true")
      set_slots([])
    end

    test "the header isn't added to the struct" do
      struct =
        build_struct(raw_headers: %{"bbc-mvt-1" => "experiment;button_colour;red"})
        |> Mvt.Mapper.map()

      assert struct.private.mvt == %{}
    end
  end

  describe "when there is a slot in the project but no corresponding mvt request header" do
    setup do
      stub_dial(:mvt_enabled, "true")
      set_slots([%{"header" => "bbc-mvt-1", "key" => "button_colour"}])
    end

    test "the header isn't added to the struct" do
      struct = build_struct([]) |> Mvt.Mapper.map()
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
      struct = build_struct(raw_headers: %{"bbc-mvt-1" => "experiment;button_colour;red"}) |> Mvt.Mapper.map()
      assert struct.private.mvt == %{}
    end
  end

  describe "when there are no mvt request headers" do
    setup do
      stub_dial(:mvt_enabled, "true")
      :ok
    end

    test "the mvt map is empty" do
      struct = build_struct(raw_headers: %{"a" => "header"}) |> Mvt.Mapper.map()

      assert %{} == struct.private.mvt
    end
  end

  describe "when a header has the key 'mvt-*' and the environment is 'test'" do
    # we will assume the environment is test here as `Belfrage.Mvt.Allowlist`
    # should filter out override headers when not on test.

    test "apply override header mapping" do
      struct = build_struct(raw_headers: %{"mvt-some_experiment" => "experiment;some_value"}) |> Mvt.Mapper.map()

      assert %{"mvt-some_experiment" => {:override, "experiment;some_value"}} == struct.private.mvt
    end
  end

  defp set_slots(project) do
    Mvt.Slots.set(%{"1" => project})
    on_exit(fn -> Mvt.Slots.set(%{}) end)
    :ok
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
