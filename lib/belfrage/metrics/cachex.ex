defmodule Belfrage.Metrics.Cachex do
  @moduledoc """
  This module is called by `:telemetry_poller` to periodically collect
  metrics from the `:cachex` cache.
  """

  import Cachex.Spec
  alias Belfrage.Metrics

  def track(cache) do
    case Cachex.size(cache) do
      {:ok, size} ->
        cache_memory = get_cache_memory(cache)

        Metrics.measurement(
          [:cachex, :stats],
          %{
            size: size,
            cache_memory: cache_memory,
            average_cache_entry_size: get_avg_cache_entry_size(cache_memory, size),
            limit: get_cache_limit(cache)
          },
          %{cache_name: cache}
        )

      _ ->
        :ok
    end
  end

  def measurements() do
    [:cache_memory, :average_cache_entry_size, :limit, :size]
  end

  defp get_cache_memory(cache) do
    fold_fn = fn
      {:entry, _key, _timestamp, _ttl, val}, acc when is_binary(val) -> acc + byte_size(val)
      {:entry, _key, _timestamp, _ttl, val}, acc -> acc + :erlang.external_size(val)
    end

    :ets.foldl(fold_fn, 0, cache)
  end

  defp get_avg_cache_entry_size(_cache_memory, 0), do: 0
  defp get_avg_cache_entry_size(cache_memory, size), do: round(cache_memory / size)

  defp get_cache_limit(cache) do
    {:ok, cache(limit: limit(size: size_limit))} = Cachex.inspect(cache, :cache)
    size_limit
  end
end
