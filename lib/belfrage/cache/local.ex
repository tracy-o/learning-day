defmodule Belfrage.Cache.Local do
  @behaviour Belfrage.Behaviours.CacheStrategy

  alias Belfrage.Behaviours.CacheStrategy
  import Belfrage.Metrics.LatencyMonitor, only: [checkpoint: 2]

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
  def fetch(%Belfrage.Struct{request: %{request_id: request_id, request_hash: request_hash}}, cache \\ :cache) do
    Cachex.touch(cache, request_hash)

    checkpoint(request_id, :request_end)
    # TODO: this temporary variable is inefficient, potentially use Kernel.tap/2
    # when available. https://github.com/bbc/belfrage/pull/844#discussion_r628017111
    result = Cachex.get(cache, request_hash)
    checkpoint(request_id, :response_start)

    format_cache_result(result)
  end

  # Not cacheable if no max age - will not be able to determine if fresh or stale.
  @impl CacheStrategy
  def store(
        %Belfrage.Struct{
          response: %Belfrage.Struct.Response{cache_directive: %Belfrage.CacheControl{max_age: max_age}}
        },
        _cache
      )
      when is_nil(max_age) do
    {:ok, false}
  end

  @impl CacheStrategy
  def store(
        struct = %Belfrage.Struct{
          response: %Belfrage.Struct.Response{
            cache_last_updated: cache_last_updated,
            cache_directive: %Belfrage.CacheControl{max_age: max_age}
          }
        },
        cache \\ :cache
      ) do
    case stale?(cache_last_updated, max_age) do
      true ->
        Cachex.put(
          cache,
          struct.request.request_hash,
          %{struct.response | cache_last_updated: Belfrage.Timer.now_ms()},
          ttl: struct.private.fallback_ttl
        )

      false ->
        {:ok, false}
    end
  end

  @impl CacheStrategy
  def metric_identifier, do: "local"

  defp format_cache_result({:ok, response = %Belfrage.Struct.Response{cache_last_updated: last_updated}})
       when not is_nil(last_updated) do
    %{max_age: max_age} = response.cache_directive

    case stale?(last_updated, max_age) do
      true -> {:ok, :stale, response}
      false -> {:ok, :fresh, response}
    end
  end

  defp format_cache_result({:ok, nil}) do
    {:ok, :content_not_found}
  end

  defp stale?(nil, _max_age), do: true

  defp stale?(last_updated, max_age) do
    Belfrage.Timer.stale?(last_updated, max_age)
  end
end
