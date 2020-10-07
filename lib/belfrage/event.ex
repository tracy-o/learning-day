defmodule Belfrage.Event do
  @moduledoc """
  Record metrics & logs.
  """

  @dimension_keys [:request_id, :spec_id]

  alias Belfrage.{Event, Monitor}
  defstruct [:request_id, :type, :data, :timestamp, dimensions: %{}]

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
    dimensions = build_dimensions(opts)

    %Event{
      request_id: Map.get(dimensions, :request_id, nil),
      dimensions: dimensions,
      type: {:metric, type},
      data: {metric, value(opts)},
      timestamp: DateTime.utc_now()
    }
  end

  def new(:log, level, msg, opts) do
    dimensions = build_dimensions(opts)

    %Event{
      request_id: Map.get(dimensions, :request_id, nil),
      dimensions: dimensions,
      type: {:log, level},
      data: msg,
      timestamp: DateTime.utc_now()
    }
  end

  defp value(opts), do: Keyword.get(opts, :value, 1)

  defp build_dimensions(opts) do
    opts
    |> Keyword.take(@dimension_keys)
    |> Enum.into(Stump.metadata())
  end

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
