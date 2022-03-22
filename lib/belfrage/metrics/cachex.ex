defmodule Belfrage.Metrics.Cachex do
  @moduledoc """
  This module is called by `:telemetry_poller` to periodically collect
  metrics from the `:cachex` cache.
  """

  import Telemetry.Metrics
  alias Belfrage.Metrics

  def metrics() do
    for measurement <- ~w(evictions expirations hits misses updates writes)a do
      last_value([:cachex, measurement],
        measurement: measurement,
        event_name: "belfrage.cachex.stats",
        tags: [:cache_name, :BBCEnvironment]
      )
    end
  end

  def track(cache) do
    Cachex.stats(cache)
    |> case do
      {:ok, stats} ->
        Metrics.measurement([:cachex, :stats], stats, %{cache_name: cache})

      _ ->
        nil
    end
  end
end
