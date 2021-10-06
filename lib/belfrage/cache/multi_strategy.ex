defmodule Belfrage.Cache.MultiStrategy do
  @moduledoc """
  Calls multiple modules that implement the `CacheStrategy` behaviour.

  fetch/2 returns cached response which meets the accepted_freshness
  criteria. The valid_caches_for_freshness/1 function ensures we check the
  Local cache first, before checking the distributed cache, and that we only
  check the distributed cache when a `:stale` freshness is acceptable.

  store/1 calls all the cache strategies (caches) to store the struct.

  This is not quite a CacheStrategy itself, but implements a very similar interface
  of fetch/2 and store/1.
  """
  alias Belfrage.{Cache.Local, Cache.Distributed, Metrics.Statix, Event}

  @default_result {:ok, :content_not_found}

  @doc """
  Tries the Local and Distributed caches
  and returns early if they return a cached response
  which matches the accepted_freshness range provided.
  """
  def fetch(struct, accepted_freshness) do
    accepted_freshness
    |> valid_caches_for_freshness()
    |> fetch(struct, accepted_freshness)
  end

  def fetch(caches, struct, accepted_freshness) do
    caches
    |> Enum.reduce_while(@default_result, fn cache, _result ->
      execute_fetch(cache, struct, accepted_freshness)
    end)
  end

  def store(struct) do
    Local.store(struct)
    Distributed.store(struct)

    :ok
  end

  def valid_caches_for_freshness(accepted_freshness) do
    case :stale in accepted_freshness do
      true -> [Local, Distributed]
      false -> [Local]
    end
  end

  defp execute_fetch(cache, struct, accepted_freshness) do
    cache_metric = cache.metric_identifier()

    with {:ok, {strategy, freshness}, response} <- cache.fetch(struct),
         true <- freshness in accepted_freshness do
      Event.record(:metric, :increment, "cache.#{cache_metric}.#{freshness}.hit")

      metric_on_stale_routespec(struct, cache_metric, freshness)
      {:halt, {:ok, {strategy, freshness}, response}}
    else
      # TODO? we could match here on `false` and record a metric that
      # shows when we asked for a `fresh` response, but only a
      # stale one exists.

      _content_not_found_or_not_accepted_freshness ->
        Event.record(:metric, :increment, "cache.#{cache_metric}.miss")
        {:cont, {:ok, :content_not_found}}
    end
  end

  defp metric_on_stale_routespec(%Belfrage.Struct{private: %{loop_id: loop_id}}, cache_metric, :stale) do
    Statix.increment("cache.#{loop_id}.#{cache_metric}.stale.hit", 1, tags: Event.global_dimensions())
  end

  defp metric_on_stale_routespec(_struct, _cache_metric, _freshness), do: nil
end
