defmodule Belfrage.Utils.DateTimeTest do
  use ExUnit.Case

  describe "beginning_of_the_current_hour/0" do
    test "time travels to the beginning of the hour" do
      {:ok, dt} = DateTime.new(~D[2022-12-02], ~T[11:54:56.368815Z], "Etc/UTC")
      amended_dt = Belfrage.Utils.DateTime.beginning_of_the_hour(dt)

      assert amended_dt == ~U[2022-12-02 11:00:00Z]

      # tests that a Datetime is actually returned, and the difference in minutes is correct
      assert (DateTime.diff(dt, amended_dt, :second) / 60) |> Float.floor() == 54
    end
  end
end
