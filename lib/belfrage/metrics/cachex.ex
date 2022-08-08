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
        Metrics.measurement([:cachex, :stats], fill_in_blanks(stats), %{cache_name: cache})

      _ ->
        nil
    end
  end

  def measurements() do
    ~w(evictions expirations hits misses updates writes)a
  end

  defp fill_in_blanks(stats) do
    measurements()
    |> Enum.reduce(stats, fn measurement, stats ->
      Map.update(stats, measurement, 0, fn value -> value end)
    end)
  end
end
