defmodule Belfrage.Services.Webcore.Helpers.Utf8SanitiserTest do
  alias Belfrage.Services.Webcore.Helpers.Utf8Sanitiser

  use ExUnit.Case

  test "When content is already sane utf-8" do
    assert %{"foo" => "abc123"} == Utf8Sanitiser.utf8_sanitise_query_params(%{"foo" => "abc123"})
  end

  test "When content is already sane utf-8, containing some unusual, but valid characters" do
    assert %{"foo" => "abc123 €%éöœ"} == Utf8Sanitiser.utf8_sanitise_query_params(%{"foo" => "abc123 €%éöœ"})
  end

  test "When content is already sane utf-8, containing some unusual, but valid characters in a nested hash" do
    assert %{"foo" => %{"bar" => "abc123 €%éöœ"}} ==
             Utf8Sanitiser.utf8_sanitise_query_params(%{"foo" => %{"bar" => "abc123 €%éöœ"}})
  end

  test "When content is not sane utf-8" do
    assert %{"foo" => "abc123�321cba"} ==
             Utf8Sanitiser.utf8_sanitise_query_params(%{"foo" => "abc123" <> <<179>> <> "321cba"})
  end
end
