defmodule Belfrage.Event do
  @moduledoc """
  Record metrics & logs.
  """

  alias Belfrage.{Event, Monitor}
  defstruct [:request_id, :type, :data, :timestamp]

  def record(type, level, msg, opts \\ [])

  def record(:log, level, msg, opts) do
    new(:log, level, msg, opts)
    |> Monitor.record_event()

    Stump.log(level, msg)
  end

  def record(:metric, type, metric, opts) do
    new(:metric, type, metric, opts)
    |> Monitor.record_event()

    apply(ExMetrics, type, [metric, value(opts)])
  end

  def new(:metric, type, metric, opts) do
    %Event{
      request_id: request_id(opts),
      type: {:metric, type},
      data: {metric, value(opts)},
      timestamp: DateTime.utc_now()
    }
  end

  def new(:log, level, msg, opts) do
    %Event{
      request_id: request_id(opts),
      type: {:log, level},
      data: msg,
      timestamp: DateTime.utc_now()
    }
  end

  defp value(opts), do: Keyword.get(opts, :value, 1)

  defp request_id(opts), do: Keyword.get(opts, :request_id, Process.get(:request_id))

  defmacro record(key, do: yield) do
    quote do
      before_time = :os.timestamp()
      result = unquote(yield)
      after_time = :os.timestamp()
      diff = :timer.now_diff(after_time, before_time)

      Belfrage.Event.record(:metric, :timing, unquote(key), value: diff / 1_000)
      result
    end
  end
end
