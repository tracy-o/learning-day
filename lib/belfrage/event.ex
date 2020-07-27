defmodule Belfrage.Event do
  def record(:log, level, msg), do: Stump.log(level, msg)

  def record(:metric, type, metric, value \\ 1) do
    apply(ExMetrics, type, [metric, value])
  end

  defmacro record(key, do: yield) do
    quote do
      before_time = :os.timestamp()
      result = unquote(yield)
      after_time = :os.timestamp()
      diff = :timer.now_diff(after_time, before_time)

      Belfrage.Event.record(:metric, :timing, unquote(key), diff / 1_000)
      result
    end
  end
end
