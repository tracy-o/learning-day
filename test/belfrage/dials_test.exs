defmodule Belfrage.DialsTest do
  use ExUnit.Case, async: true

  alias Belfrage.Dials

  @dials_location Application.get_env(:belfrage, :dials_location)

  test "Dials.state() returns ttl_multiplier dial value" do
    assert Dials.state() == %{ttl_multiplier: "1"}
  end

  test "Changing the file and refreshing gives the new dials value" do
    original_dials = File.read!(@dials_location)
    File.write!(@dials_location, Eljiffy.encode!(%{ttl_multipler: "2"}))

    Process.send(:dials, :refresh, [])
    assert Dials.state() == %{ttl_multiplier: "2"}

    File.write!(@dials_location, original_dials)
  end
end
