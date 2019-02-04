defmodule Ingress.CounterTest do
  use ExUnit.Case

  alias Ingress.Counter

  test "increments a value" do
    state = Counter.init
    |> Counter.inc(200)
    |> Counter.inc(200)
    |> Counter.inc(500)

    assert Counter.get(state, 200) == 2
    assert Counter.get(state, 500) == 1
    assert Counter.get(state, 401) == 0
  end

  test "error codes increment a global :errors counter" do
    state = Counter.init
    |> Counter.inc(200)
    |> Counter.inc(500)
    |> Counter.inc(500)
    |> Counter.inc(502)
    |> Counter.inc(408)

    assert Counter.get(state, :errors) == 4
  end

  test "returns true if count is over the passed threshold" do
    state = Counter.init
    |> Counter.inc(500)
    |> Counter.inc(500)
    |> Counter.inc(500)
    |> Counter.inc(500)

    assert Counter.get(state, 500) == 4
    assert Counter.exceed?(state, 500, 3) == true
    assert Counter.exceed?(state, 200, 3) == false
  end

  test "will not accept an increment of the :error key as it's used internally" do
    state = Counter.init

    assert Counter.inc(state, :error) == {:ko, "key not allowed: ':error'"}
  end
end
