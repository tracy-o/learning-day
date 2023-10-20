defmodule ExampleModifierTest do
  use ExUnit.Case
  doctest ExampleModifier

  test "greets the world" do
    assert ExampleModifier.hello() == :world
  end
end
