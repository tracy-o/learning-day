defmodule Belfrage.Metrics.Cachex do
  @moduledoc """
  This module is called by `:telemetry_poller` to periodically collect
  metrics from the `:cachex` cache.
  """

  alias Belfrage.Metrics

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
