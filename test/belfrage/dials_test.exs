defmodule Belfrage.DialsTest do
  use ExUnit.Case, async: true

  alias Belfrage.Dials

  @dials_location Application.get_env(:belfrage, :dials_location)

  setup do
    Dials.init(nil)
    original_dials = File.read!(@dials_location)

    on_exit(fn ->
      File.write!(@dials_location, original_dials)
      Process.send(:dials, :refresh, [])
    end)

    :ok
  end

  test "Dials.state() returns ttl_multiplier dial value" do
    assert Dials.state() == %{"ttl_multiplier" => "1"}
  end

  test "Changing the file and refreshing gives the new dials value" do
    File.write!(@dials_location, Eljiffy.encode!(%{ttl_multiplier: "2"}))

    Process.send(:dials, :refresh, [])
    assert Dials.state() == %{"ttl_multiplier" => "2"}
  end

  test "Writing unparsable JSON to the file returns the initial dials values" do
    File.write!(@dials_location, "{}}}}\\inva\"id: \nJSON!!</what?>}")

    Process.send(:dials, :refresh, [])
    assert Dials.state() == %{"ttl_multiplier" => "1"}
  end

  test "A missing file returns the initial dials values" do
    File.rm(@dials_location)

    Process.send(:dials, :refresh, [])
    assert Dials.state() == %{"ttl_multiplier" => "1"}
  end
end
