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
  @dial Application.get_env(:belfrage, :dial)

  @doc """
  Tries the Local and Distributed caches
  and returns early if they return a cached response
  which matches the accepted_freshness range provided.
  """
  def fetch(struct, accepted_freshness) do
    accepted_freshness
    |> valid_caches(struct)
    |> fetch(struct, accepted_freshness)
  end

  def fetch(caches, struct, accepted_freshness) do
    caches
    |> Enum.reduce_while(@default_result, fn cache, _result ->
      execute_fetch(cache, struct, accepted_freshness)
    end)
  end

  def store(struct) do
    if @dial.state(:ccp_enabled) do
      Local.store(struct)
      Distributed.store(struct)
    else
      Local.store(struct)
    end

    :ok
  end

  def valid_caches(accepted_freshness, struct) do
    if should_use_distributed?(accepted_freshness, struct) do
      [Local, Distributed]
    else
      [Local]
    end
  end

  defp should_use_distributed?(accepted_freshness, struct) do
    @dial.state(:ccp_enabled) and :stale in accepted_freshness and struct.private.fallback_write_sample > 0
  end

  defp execute_fetch(cache, struct, accepted_freshness) do
    cache_metric = cache.metric_identifier()

    with {:ok, {strategy, freshness}, response} <- cache.fetch(struct),
         true <- freshness in accepted_freshness do
      :telemetry.execute([:belfrage, :cache, String.to_atom(cache_metric), freshness, :hit], %{}, %{
        route_spec: struct.private.route_state_id
      })

      metric_on_stale_routespec(struct, cache_metric, freshness)
      {:halt, {:ok, {strategy, freshness}, response}}
    else
      # TODO? we could match here on `false` and record a metric that
      # shows when we asked for a `fresh` response, but only a
      # stale one exists.

      _content_not_found_or_not_accepted_freshness ->
        :telemetry.execute([:belfrage, :cache, String.to_atom(cache_metric), :miss], %{}, %{
          route_spec: struct.private.route_state_id
        })

        {:cont, {:ok, :content_not_found}}
    end
  end

  defp metric_on_stale_routespec(%Belfrage.Struct{private: %{route_state_id: route_state_id}}, cache_metric, :stale) do
    Statix.increment("cache.#{route_state_id}.#{cache_metric}.stale.hit", 1, tags: Event.global_dimensions())
  end

  defp metric_on_stale_routespec(_struct, _cache_metric, _freshness), do: nil
end
