defmodule BelfrageWeb.ValidatorsTest do
  use ExUnit.Case
  alias BelfrageWeb.Validators

  describe "in_range?" do
    test "an integer" do
      assert Validators.in_range?("2", 1..999) == true
    end

    test "a string" do
      assert Validators.in_range?("a", 1..999) == false
    end

    test "a decimal" do
      assert Validators.in_range?("1.5", 1..999) == false
    end

    test "against a set of values" do
      assert Validators.in_range?("404", [404, 500]) == true
      assert Validators.in_range?("405", [404, 500]) == false
      assert Validators.in_range?("500", [404, 500]) == true
    end
  end

  describe "matches?" do
    test "matches the regex" do
      assert Validators.matches?("123a", ~r/^\d{1,4}[a-f]?$/) == true
      assert Validators.matches?("a123a", ~r/^\d{1,4}[a-f]?$/) == false
      assert Validators.matches?("123z", ~r/^\d{1,4}[a-f]?$/) == false
    end
  end

  describe "is_language?" do
    test "is an ISO value" do
      assert Validators.is_language?("en") == true
      assert Validators.is_language?("english") == false
    end
  end

  describe "is_valid_length?" do
    test "matches range" do
      assert Validators.is_valid_length?("abc", 1..3) == true
      assert Validators.is_valid_length?("123", 1..3) == true
      assert Validators.is_valid_length?("abcd", 1..3) == false
      assert Validators.is_valid_length?("", 1..3) == false
    end
  end

  describe "starts_with?" do
    test "validate beginning of the string" do
      assert Validators.starts_with?("/weather", "/") == true
      assert Validators.starts_with?("weather", "/") == false
    end
  end
end
