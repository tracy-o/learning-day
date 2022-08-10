defmodule Belfrage.Metrics do
  @moduledoc """
  This module should be used to emit telemetry events instead of calling
  `:telemetry` directly. It encapsulates our telemetry conventions.
  """

  @type event_name :: atom() | [atom()]
  @type start_time :: integer()
  @type measurements :: map()
  @type metadata :: map()

  @event_prefix :belfrage
  @time_unit :nanosecond

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
    start_time = System.monotonic_time(@time_unit)
    result = func.()
    stop(name, start_time, metadata)
    result
  end

  @doc """
  Record an event with optional metadata.
  """
  @spec event(event_name(), metadata()) :: :ok
  def event(name, metadata \\ %{}), do: event(name, %{}, metadata)

  @doc """
  Records the end of an event span. Emits a `[prefix, name, :stop]` event with
  a `duration` measurement calculated using the passed `start_time` which must
  be the result of calling `System.monotonic_time/0` at the beginning of the
  event span.
  """
  @spec stop(event_name(), start_time(), metadata()) :: :ok
  def stop(name, start_time, metadata \\ %{}) do
    duration = System.monotonic_time(@time_unit) - start_time
    os_start_time = System.os_time(@time_unit) - duration

    name
    |> suffix_name(:stop)
    |> event(%{duration: duration, start_time: os_start_time}, metadata)
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

  ### PROMETHEUS MIGRATION

  def latency_stop(name, start_time) do
    duration = System.monotonic_time(@time_unit) - start_time

    :telemetry.execute([:belfrage, name, :stop], %{duration: duration})
    :telemetry.execute([:belfrage, :latency, :stop], %{duration: duration}, %{function_name: name})
  end

  def multi_execute(events, measurements, metadata) do
    for event <- events do
      :telemetry.execute(event, measurements, metadata)
    end
  end

  # See https://github.com/beam-telemetry/telemetry/blob/091121f6153840fd079e68940715a5c35c5aa445/src/telemetry.erl#L310
  def multi_span(event_prefixes, start_metadata, span_function) do
    start_time = :erlang.monotonic_time()

    multi_execute(
      for event_prefix <- event_prefixes do
        event_prefix ++ [:start]
      end,
      %{monotonic_time: start_time, system_time: :erlang.system_time()},
      start_metadata
    )

    try do
      {result, %{} = stop_metadata} = span_function.()

      stop_time = :erlang.monotonic_time()

      multi_execute(
        for event_prefix <- event_prefixes do
          event_prefix ++ [:stop]
        end,
        %{duration: stop_time - start_time, monotonic_time: stop_time},
        stop_metadata
      )

      result
    catch
      kind, reason ->
        stop_time = :erlang.monotonic_time()

        multi_execute(
          for event_prefix <- event_prefixes do
            event_prefix ++ [:exception]
          end,
          %{duration: stop_time - start_time, monotonic_time: stop_time},
          Map.merge(start_metadata, %{kind: kind, reason: reason, stacktrace: __STACKTRACE__})
        )

        :erlang.raise(kind, reason, __STACKTRACE__)
    end
  end

  # TODO remove after statsd to prometheus migration
  def latency_span(name, func) do
    multi_span([[:belfrage, name], [:belfrage, :latency]], %{}, fn ->
      result = func.()
      {result, %{function_name: name}}
    end)
  end

  # TODO remove after statsd to prometheus migration
  def request_span(name, func) do
    multi_span([[:belfrage, :request, name], [:belfrage, :request]], %{}, fn ->
      result = func.()
      {result, %{authentication_type: name}}
    end)
  end
end
