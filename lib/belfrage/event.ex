defmodule Belfrage.Event do
  @moduledoc """
  Record metrics & logs.
  """

  @dimension_keys [:request_id, :loop_id]

  @monitor_api Application.get_env(:belfrage, :monitor_api)

  @callback record(atom(), any(), any(), any()) :: any()
  @callback record(atom(), any(), any()) :: any()

  alias Belfrage.Event
  defstruct [:request_id, :type, :data, :timestamp, dimensions: %{}]

  def record(type, level, msg, opts \\ [])

  def record(:log, level, msg, cloudwatch: true) do
    Stump.log(level, msg, cloudwatch: true)
  end

  def record(:log, level, msg, opts) do
    new(:log, level, msg, opts)
    |> @monitor_api.record_event()

    Stump.log(level, msg)
    Stump.log(level, msg, cloudwatch: true)
  end

  def record(:metric, type, metric, opts) do
    new(:metric, type, metric, opts)
    |> @monitor_api.record_event()

    apply(Belfrage.Metrics.Statix, type, [metric, value(opts)])
  end

  def new(log_or_metric, name, payload, opts \\ [])

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
