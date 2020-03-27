defmodule Belfrage.Cache.MultiStrategy do
  @moduledoc """
  Calls multiple modules that implement the `CacheStrategy` behaviour.

  fetch/2 returns the first cached response which meets the accepted_freshness
  criteria.

  store/1 calls all the cache strategies (caches) to store the struct.

  This is not quite a CacheStrategy itself, but implements a very similar interface
  of fetch/2 and store/1.
  """
  alias Belfrage.Cache.{Local, Distributed}

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
    with {:ok, freshness, response} <- cache.fetch(struct),
         true <- freshness in accepted_freshness do
      ExMetrics.increment("cache.#{cache_metric}.#{freshness}.hit")
      {:halt, {:ok, freshness, response}}
    else
      # TODO? we could match here on `false` and record a metric that
      # shows when we asked for a `fresh` response, but only a
      # stale one exists.

      _content_not_found_or_not_accepted_freshness ->
        ExMetrics.increment("cache.#{cache_metric}.miss")
        {:cont, {:ok, :content_not_found}}
    end
  end
end
