defmodule Ingress.CounterTest do
  use ExUnit.Case

  alias Ingress.Counter

  @origin "https://origin.bbc.com/"

  test "increments a value" do
    state =
      Counter.init()
      |> Counter.inc(200, @origin)
      |> Counter.inc(200, @origin)
      |> Counter.inc(500, @origin)

    assert Counter.get(state[@origin], 200) == 2
    assert Counter.get(state[@origin], 500) == 1
    assert Counter.get(state[@origin], 401) == 0
  end

  test "error codes increment a global :errors counter" do
    state =
      Counter.init()
      |> Counter.inc(200, @origin)
      |> Counter.inc(500, @origin)
      |> Counter.inc(500, @origin)
      |> Counter.inc(502, @origin)
      |> Counter.inc(408, @origin)
    assert Counter.get(state, :errors) == 4
  end

  test "returns true if count is over the passed threshold" do
    state =
      Counter.init()
      |> Counter.inc(500, @origin)
      |> Counter.inc(500, @origin)
      |> Counter.inc(500, @origin)
      |> Counter.inc(500, @origin)

    assert Counter.get(state[@origin], 500) == 4
    assert Counter.exceed?(state[@origin], 500, 3) == true
    assert Counter.exceed?(state[@origin], 200, 3) == false
  end

  test "will not accept an increment of the :error key as it's used internally" do
    state = Counter.init()

    assert Counter.inc(state, :error, @origin) == {:error, "key not allowed: ':error'"}
  end
end
