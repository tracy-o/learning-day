defmodule Belfrage.Event do
  defmacro record_span(key, do: yield) do
    quote do
      before_time = :os.timestamp()
      result = unquote(yield)
      after_time = :os.timestamp()
      diff = :timer.now_diff(after_time, before_time)

      :telemetry.execute(unquote(key), %{duration: diff / 1_000})
      result
    end
  end
end
