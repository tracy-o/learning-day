defmodule Belfrage.Cache.Cleaner do
  @behaviour EtsCleaner.ICleanEtsTables

  # Danger close! clean everything older than 1 hour
  def clean(mem) when mem >= 90 do
    :ets.select_delete(:cache, filter_older_than(:timer.minutes(30)))
  end

  def clean(mem) when mem >= 80 do
    :ets.select_delete(:cache, filter_older_than(:timer.hours(1)))
  end

  def clean(mem) when mem >= 75 do
    :ets.select_delete(:cache, filter_older_than(:timer.hours(5)))
  end

  # don't clean the cache when we still have room
  def clean(_), do: 0

  defp filter_older_than(age) do
    Cachex.Query.raw({:<, :"$2", Belfrage.Timer.now_ms() - age}, true)
  end
end
