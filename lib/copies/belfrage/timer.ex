defmodule Belfrage.Timer do
  def stale?(time_stored, ttl) do
    time_stored + sec_to_ms(ttl) < now_ms()
  end

  def now_ms do
    :os.system_time(:millisecond)
  end

  # Convert a duration in seconds to milliseconds
  def sec_to_ms(seconds) when is_number(seconds) do
    seconds * 1_000
  end

  def make_stale(time_stored, ttl) do
    time_stored - sec_to_ms(ttl) - 1_000
  end
end
