defmodule Belfrage.Helpers.QueryParamsTest do
  use ExUnit.Case
  alias Belfrage.Helpers.QueryParams

  # This is currently in alphabetical order, follow up PR will come to fix the QueryParams Helper ordering
  test "returns a string built from query params map in order" do
    query_params = %{"enabled" => "true", "disabled" => "false", "ordered" => "true"}

    assert "?disabled=false&enabled=true&ordered=true" == QueryParams.parse(query_params)
  end

  test "they are definitely in the right order" do
    query_params = %{"disabled" => "false", "enabled" => "true"}

    refute "?enabled?true?disabled=false" == QueryParams.parse(query_params)
  end

  test "it can handle a nested query params" do
    query_params = %{"options" => %{"enabled" => "true", "disabled" => "false", "elixir" => "cool"}}

    assert "?options[disabled]=false&options[elixir]=cool&options[enabled]=true" == QueryParams.parse(query_params)
  end

  test "it can handle a deeply nested map" do
    query_params = %{"options" => %{"enabled" => "true", "disabled" => "false", "elixir" => %{"is" => "cool"}}}

    assert "?options[disabled]=false&options[elixir][is]=cool&options[enabled]=true" == QueryParams.parse(query_params)
  end
end
