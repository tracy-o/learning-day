defmodule Belfrage.Dials.CacheEnabledTest do
  use ExUnit.Case, async: true
  alias Belfrage.Dials.CacheEnabled

  test "transform/1 converts string representation of 'true' to boolean" do
    assert CacheEnabled.transform("true") == true
  end

  test "transform/1 converts string representation of 'false' to boolean" do
    assert CacheEnabled.transform("false") == false
  end
end
