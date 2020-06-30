defmodule Belfrage.Dials.DefaultsTest do
  use ExUnit.Case, async: true

  import Belfrage.Dials.Defaults
  alias Belfrage.Dials

  @dial "circuit_breaker"
  @codec Application.get_env(:belfrage, :json_codec)
  @cosmos_dials File.read!("cosmos/dials.json") |> @codec.decode!()

  # priv/static/dials.json = cosmos/dials.json
  test "cosmos_dials/0 returns up-to-data data" do
    assert Dials.Defaults.cosmos_dials() == @cosmos_dials
  end

  test "default/0 transforms and returns the string default state in Cosmos dials.json" do
    dial = @cosmos_dials |> Enum.find(&(&1["name"] == @dial))
    assert Dials.CircuitBreaker.default() == transform(dial["default-value"], @dial)
  end

  test "all dial values in Cosmos dials.json are transformed into booleans" do
    dial = @cosmos_dials |> Enum.find(&(&1["name"] == @dial))

    for dial <- dial["values"] do
      assert dial["value"] |> transform(@dial) |> is_boolean()
    end
  end
end
