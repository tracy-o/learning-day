defmodule Belfrage.Dials.NaidheachdanObitTest do
  use ExUnit.Case, async: true
  alias Belfrage.Dials.NaidheachdanObit

  test "transform/1 converts string representation of 'on' to boolean" do
    assert NaidheachdanObit.transform("on") === true
  end

  test "transform/1 converts string representation of 'off' to boolean" do
    assert NaidheachdanObit.transform("off") === false
  end
end
