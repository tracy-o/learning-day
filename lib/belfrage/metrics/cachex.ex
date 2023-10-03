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
        Metrics.measurement([:cachex, :stats], %{size: size}, %{cache_name: cache})

      _ ->
        :ok
    end
  end

  def track_cache_memory(cache) do
    with {:ok, size} when size != 0 <- Cachex.size(cache) do
      cache_memory = get_cache_memory(cache)

      Metrics.measurement(
        [:cachex, :stats],
        %{
          cache_memory: cache_memory,
          average_cache_entry_size: round(cache_memory / size),
          limit: get_cache_limit(cache)
        },
        %{cache_name: cache}
      )
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

  defp get_cache_limit(cache) do
    {:ok, cache(limit: limit(size: size_limit))} = Cachex.inspect(cache, :cache)
    size_limit
  end
end
