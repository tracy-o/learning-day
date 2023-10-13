defmodule Belfrage.Cache.MultiStrategy do
  @moduledoc """
  Calls multiple modules that implement the `CacheStrategy` behaviour.

  fetch/2 returns cached response which meets the accepted_freshness
  criteria. The valid_caches_for_freshness/1 function ensures we check the
  Local cache first, before checking the distributed cache, and that we only
  check the distributed cache when a `:stale` freshness is acceptable.

  store/1 calls all the cache strategies (caches) to store the envelope.

  This is not quite a CacheStrategy itself, but implements a very similar interface
  of fetch/2 and store/1.
  """
  alias Belfrage.{Cache.Local, Cache.Distributed, RouteState}

  @default_result {:ok, :content_not_found}
  @dial Application.compile_env(:belfrage, :dial)

  @doc """
  Tries the Local and Distributed caches
  and returns early if they return a cached response
  which matches the accepted_freshness range provided.
  """
  def fetch(envelope, accepted_freshness) do
    accepted_freshness
    |> valid_caches(envelope)
    |> fetch(envelope, accepted_freshness)
  end

  def fetch(caches, envelope, accepted_freshness) do
    caches
    |> Enum.reduce_while(@default_result, fn cache, _result ->
      execute_fetch(cache, envelope, accepted_freshness)
    end)
  end

  def store(envelope) do
    if @dial.get_dial(:ccp_enabled) do
      Local.store(envelope)
      Distributed.store(envelope)
    else
      Local.store(envelope)
    end

    :ok
  end

  def valid_caches(accepted_freshness, envelope) do
    if should_use_distributed?(accepted_freshness, envelope) do
      [Local, Distributed]
    else
      [Local]
    end
  end

  defp should_use_distributed?(accepted_freshness, envelope) do
    :stale in accepted_freshness and envelope.private.fallback_write_sample > 0 and @dial.get_dial(:ccp_enabled)
  end

  defp execute_fetch(cache, envelope, accepted_freshness) do
    cache_metric = cache.metric_identifier()
    route_spec = RouteState.format_id(envelope.private.route_state_id)

    with {:ok, {strategy, freshness}, response} <- cache.fetch(envelope),
         true <- freshness in accepted_freshness do
      :telemetry.execute([:belfrage, :cache, String.to_atom(cache_metric), freshness, :hit], %{}, %{
        route_spec: route_spec
      })

      metric_on_stale_routespec(route_spec, cache_metric, freshness)
      {:halt, {:ok, {strategy, freshness}, response}}
    else
      # TODO? we could match here on `false` and record a metric that
      # shows when we asked for a `fresh` response, but only a
      # stale one exists.

      _content_not_found_or_not_accepted_freshness ->
        :telemetry.execute([:belfrage, :cache, String.to_atom(cache_metric), :miss], %{}, %{
          route_spec: route_spec
        })

        {:cont, {:ok, :content_not_found}}
    end
  end

  defp metric_on_stale_routespec(route_state_id, cache_metric, :stale) do
    Belfrage.Metrics.multi_execute(
      [[:belfrage, :cache, route_state_id, cache_metric, :stale, :hit], [:belfrage, :cache, :stale, :hit]],
      %{count: 1},
      %{
        route_state: route_state_id,
        cache_metric: cache_metric
      }
    )
  end

  defp metric_on_stale_routespec(_envelope, _cache_metric, _freshness), do: nil
end
