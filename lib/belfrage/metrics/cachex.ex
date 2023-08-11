defmodule Belfrage.Metrics.Cachex do
  @moduledoc """
  This module is called by `:telemetry_poller` to periodically collect
  metrics from the `:cachex` cache.
  """

  alias Belfrage.Metrics

  def track(cache) do
    with {:ok, stats} <- Cachex.stats(cache),
         {:ok, size} <- Cachex.size(cache) do
      Metrics.measurement([:cachex, :stats], fill_in_blanks(Map.put(stats, :size, size)), %{cache_name: cache})
    end
  end

  def measurements() do
    ~w(evictions expirations hits misses updates writes size)a
  end

  defp fill_in_blanks(stats) do
    measurements()
    |> Enum.reduce(stats, fn measurement, stats ->
      Map.update(stats, measurement, 0, fn value -> value end)
    end)
  end
end
