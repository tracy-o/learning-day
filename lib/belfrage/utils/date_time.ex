defmodule Belfrage.Utils.DateTime do
  def beginning_of_the_hour(date_time = %DateTime{}) do
    date_time
    |> Map.merge(%{minute: 0, second: 0, microsecond: {0, 0}})
  end
end
