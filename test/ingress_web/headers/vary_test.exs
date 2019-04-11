defmodule IngressWeb.Headers.VaryTest do
  use ExUnit.Case

  alias IngressWeb.Headers.Vary

  doctest Vary

  test "module exists" do
    assert is_list(Vary.module_info())
  end
end
