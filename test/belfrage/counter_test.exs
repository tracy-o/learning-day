defmodule Belfrage.CounterTest do
  use ExUnit.Case

  alias Belfrage.Counter

  @origin "https://origin.bbc.com/"

  describe "normal response" do
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

    test "will only increment numberical values" do
      state = Counter.init()

      assert Counter.inc(state, :error, @origin) == {:error, "'status' must be an integer"}
    end
  end

  describe "response with fallback" do
    test "increments fallback count, but no other count" do
      counter =
        Counter.init()
        |> Counter.inc(200, @origin, fallback: true)

      origin_state = counter[@origin]
      assert Counter.get(origin_state, :fallback) == 1
      assert Counter.get(origin_state, 200) == 0
      assert Counter.get(origin_state, :errors) == 0
      assert Counter.get(counter, :errors) == 0
    end
  end
end
