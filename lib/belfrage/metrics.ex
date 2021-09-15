defmodule Belfrage.Metrics do
  @moduledoc """
  This module should be used to emit telemetry events instead of calling
  `:telemetry` directly. It encapsulates our telemetry conventions.
  """

  @event_prefix :belfrage

  @doc """
  Record a measurement. Name can be an atom or a list of atoms if the
  measurement needs to be prefixed. The measurement itself can be any map.
  """
  @spec measurement(name :: atom() | [atom()], measurement :: map(), metadata :: map()) :: :ok
  def measurement(name, measurement, metadata \\ %{}) do
    event =
      if is_list(name) do
        [@event_prefix | name]
      else
        [@event_prefix, name]
      end

    :telemetry.execute(event, measurement, metadata)

    :ok
  end
end
