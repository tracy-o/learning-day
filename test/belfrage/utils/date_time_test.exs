defmodule Belfrage.Utils.DateTimeTest do
  use ExUnit.Case

  describe "beginning_of_the_hour/0" do
    test "time travels to the beginning of the hour" do
      {:ok, date_time} = DateTime.new(~D[2022-12-02], ~T[11:54:56.368815Z], "Etc/UTC")

      amended_date_time = Belfrage.Utils.DateTime.beginning_of_the_hour(date_time)

      assert amended_date_time == ~U[2022-12-02 11:00:00Z]

      # tests that a Datetime is actually returned, and the difference in minutes is correct
      assert (DateTime.diff(date_time, amended_date_time, :second) / 60) |> Float.floor() == 54
    end

    test "two times whitinh the same hour will produce the same result" do
      {:ok, date_time1} = DateTime.new(~D[2022-12-02], ~T[11:45:12.165815Z], "Etc/UTC")
      {:ok, date_time2} = DateTime.new(~D[2022-12-02], ~T[11:54:56.368815Z], "Etc/UTC")

      amended_date_time1 = Belfrage.Utils.DateTime.beginning_of_the_hour(date_time1)
      amended_date_time2 = Belfrage.Utils.DateTime.beginning_of_the_hour(date_time2)

      assert amended_date_time1 == amended_date_time2
    end
  end
end
