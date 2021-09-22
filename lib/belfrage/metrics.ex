defmodule Belfrage.Metrics do
  @moduledoc """
  This module should be used to emit telemetry events instead of calling
  `:telemetry` directly. It encapsulates our telemetry conventions.
  """

  @type event_name :: atom() | [atom()]
  @type measurements :: map()
  @type metadata :: map()

  @event_prefix :belfrage

  @doc """
  Record a measurement. Name can be an atom or a list of atoms if the
  measurement needs to be prefixed. The measurement itself can be any map.
  """
  @spec measurement(event_name(), measurements(), metadata()) :: :ok
  def measurement(name, measurements, metadata \\ %{}), do: event(name, measurements, metadata)

  @doc """
  Measure duration of execution of the passed function. Emits the same event as
  `stop/3`.
  """
  @spec duration(event_name(), fun()) :: any()
  def duration(name, func), do: duration(name, %{}, func)

  @doc """
  Same as `duration/2` but accepts metadata as well.
  """
  @spec duration(event_name(), metadata(), fun()) :: any()
  def duration(name, metadata, func) do
    start_time = System.monotonic_time()
    result = func.()
    stop(name, start_time, metadata)
    result
  end

  @doc """
  Records the end of an event span. Emits a `[prefix, name, :stop]` event with
  a `duration` measurement calculated using the passed `start_time` which must
  be the result of calling `System.monotonic_time/0` at the beginning of the
  event span.
  """
  @spec stop(event_name(), start_time :: integer(), metadata()) :: :ok
  def stop(name, start_time, metadata \\ %{}) do
    name
    |> suffix_name(:stop)
    |> event(%{duration: System.monotonic_time() - start_time}, metadata)
  end

  defp event(name, measurements, metadata) do
    name
    |> prefix_name()
    |> :telemetry.execute(measurements, metadata)

    :ok
  end

  defp prefix_name(name) do
    [@event_prefix | List.wrap(name)]
  end

  defp suffix_name(name, suffix) do
    List.wrap(name) ++ [suffix]
  end
end
