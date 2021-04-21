defmodule Belfrage.Cache.Local do
  @behaviour Belfrage.Behaviours.CacheStrategy

  alias Belfrage.Behaviours.CacheStrategy

  @doc """
  Fetches a response from the local cache. In order to implement an LRU caching
  strategy[1], we touch the entry in the cache which updates its "write time" in
  ETS. This causes the configured Cachex LRW strategy to actually evict things
  based on when they were last used.

  Cachex.touch/2 updates the ETS last modified value, whereas the Belfrage stale 
  check seems to use one in the tuple with the actual response. This has been 
  tested in [2]

  - [1] https://github.com/whitfin/cachex/blob/master/docs/features/cache-limits.md#policies
  - [2] https://github.com/bbc/belfrage/pull/821/commits/761d3d68ca9a30b0b6a543ed4ff42b268ac14565
  """
  @impl CacheStrategy
  def fetch(%Belfrage.Struct{request: %{request_hash: request_hash}}, cache \\ :cache) do
    Cachex.touch(cache, request_hash)

    Cachex.get(cache, request_hash)
    |> format_cache_result()
  end

  @impl CacheStrategy
  def store(struct = %Belfrage.Struct{}, cache \\ :cache) do
    case stale?(struct, cache) do
      true ->
        Cachex.put(
          cache,
          struct.request.request_hash,
          {struct.response, Belfrage.Timer.now_ms()},
          ttl: struct.private.fallback_ttl
        )

      false ->
        {:ok, false}
    end
  end

  @impl CacheStrategy
  def metric_identifier, do: "local"

  defp format_cache_result({:ok, {response, last_updated}}) do
    %{max_age: max_age} = response.cache_directive

    case Belfrage.Timer.stale?(last_updated, max_age) do
      true -> {:ok, :stale, response}
      false -> {:ok, :fresh, response}
    end
  end

  defp format_cache_result({:ok, nil}) do
    {:ok, :content_not_found}
  end

  defp stale?(struct, cache) do
    case fetch(struct, cache) do
      {:ok, :fresh, _fetched} -> false
      _ -> true
    end
  end
end
