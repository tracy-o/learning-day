defmodule Belfrage.Dials.PersonalisationTest do
  use ExUnit.Case, async: true
  alias Belfrage.Dials.Personalisation

  test "transform/1 converts string representation of 'on' to boolean" do
    assert Personalisation.transform("on") === true
  end

  test "transform/1 converts string representation of 'off' to boolean" do
    assert Personalisation.transform("off") === false
  end
end
