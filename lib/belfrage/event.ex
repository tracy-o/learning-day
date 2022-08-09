defmodule Belfrage.Event do
  @moduledoc """
  Record metrics & logs.
  """
  require Logger

  @dimension_opts [:request_id, :route_state_id]

  @callback record(atom(), any(), any(), any()) :: any()
  @callback record(atom(), any(), any()) :: any()

  alias Belfrage.{Event}
  defstruct [:request_id, :type, :data, :timestamp, dimensions: %{}]

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
    |> Keyword.take(@dimension_opts)
    |> Enum.into(Map.new(Logger.metadata()))
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
