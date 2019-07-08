defmodule Belfrage.TimerTest do
  use ExUnit.Case
  alias Belfrage.Timer

  describe "is stale?" do
    test "returns true" do
      one_minute_ago = Timer.now_ms() - :timer.minutes(1)

      assert Timer.stale?(one_minute_ago, 30) == true
    end

    test "returns false" do
      ten_seconds_ago = Timer.now_ms() - :timer.seconds(10)

      assert Timer.stale?(ten_seconds_ago, 30) == false
    end
  end
end
