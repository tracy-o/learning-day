defmodule Belfrage.Mvt.HeadersTest do
  use ExUnit.Case, async: true

  alias Belfrage.Mvt.Headers

  describe "get?/0" do
    test "returns an empty list on startup" do
      pid = start_supervised!({Headers, name: :mvt_headers_test})
      assert Headers.get(pid) == []
    end
  end

  describe "set/1" do
    test "sets the available headers and they can be retrieved as they were" do
      pid = start_supervised!({Headers, name: :mvt_headers_test})
      assert Headers.get(pid) == []

      decoded_headers_from_s3 = %{"1" => [%{"header" => "bbc-mvt-1", "key" => "box_colour_change"}]}

      Headers.set(pid, decoded_headers_from_s3)
      assert Headers.get(pid) == decoded_headers_from_s3
    end
  end

  test "when headers are already set they will be overwritten" do
    pid = start_supervised!({Headers, name: :mvt_headers_test})
    assert Headers.get(pid) == []

    decoded_headers_from_s3 = [%{"header" => "bbc-mvt-1", "key" => "box_colour_change"}]

    Headers.set(pid, decoded_headers_from_s3)
    assert Headers.get(pid) == decoded_headers_from_s3

    new_headers = [%{"header" => "bbc-mvt-3", "key" => "fancy_new_buttons"}]

    Headers.set(pid, new_headers)
    assert Headers.get(pid) == new_headers
  end
end
