defmodule Belfrage.Timer do
  def stale?(time_stored, ttl) do
    time_stored + ttl * 1000 < now_ms()
  end

  def now_ms do
    :os.system_time(:millisecond)
  end
end
