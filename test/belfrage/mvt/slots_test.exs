defmodule Belfrage.Mvt.SlotsTest do
  use ExUnit.Case, async: true

  alias Belfrage.Mvt.Slots

  describe "get?/0" do
    test "returns an empty map on startup" do
      pid = start_supervised!({Slots, name: :mvt_headers_test})
      assert Slots.available(pid) == %{}
    end
  end

  describe "set/1" do
    test "sets the available headers and they can be retrieved as they were" do
      pid = start_supervised!({Slots, name: :mvt_headers_test})
      assert Slots.available(pid) == %{}

      decoded_headers_from_s3 = %{"1" => [%{"header" => "bbc-mvt-1", "key" => "box_colour_change"}]}

      Slots.set(pid, decoded_headers_from_s3)
      assert Slots.available(pid) == decoded_headers_from_s3
    end
  end

  test "when headers are already set they will be overwritten" do
    pid = start_supervised!({Slots, name: :mvt_headers_test})
    assert Slots.available(pid) == %{}

    decoded_headers_from_s3 = %{"header" => "bbc-mvt-1", "key" => "box_colour_change"}

    Slots.set(pid, decoded_headers_from_s3)
    assert Slots.available(pid) == decoded_headers_from_s3

    new_headers = %{"header" => "bbc-mvt-3", "key" => "fancy_new_buttons"}

    Slots.set(pid, new_headers)
    assert Slots.available(pid) == new_headers
  end
end
