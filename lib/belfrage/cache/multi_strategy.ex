defmodule Belfrage.Cache.MultiStrategy do
  @moduledoc """
  Calls multiple modules that implement the `CacheStrategy` behaviour.

  fetch/2 returns the first cached response which meets the accepted_freshness
  criteria.

  store/1 calls all the cache strategies to store the struct.

  This is not quite a CacheStrategy itself, but implements a very similar interface
  of fetch/2 and store/1.
  """
  alias Belfrage.Behaviours.CacheStrategy
  alias Belfrage.Cache.{Local, DistributedFallback}

  @default_result {:ok, :content_not_found}

  def fetch(struct, accepted_freshness) do
    accepted_freshness
    |> valid_strategies_for_freshness()
    |> Enum.reduce_while(@default_result, fn  strategy, _result ->
      execute_fetch(strategy, struct, accepted_freshness)
    end)
  end

  def store(struct) do
    Local.store(struct)
    DistributedFallback.store(struct)

    :ok
  end

  defp execute_fetch(cache_strategy, struct, accepted_freshness) do
    with {:ok, freshness, response} <- cache_strategy.fetch(struct),
         true <- freshness in accepted_freshness do
      {:halt, {:ok, freshness, response}}
    else
      _content_not_found_or_not_accepted_freshness ->
        {:cont, {:ok, :content_not_found}}
    end
  end

  defp valid_strategies_for_freshness(accepted_freshness) do
    case :stale in accepted_freshness do
      true -> [Local]
      false -> [Local, DistributedFallback]
    end
  end
end
