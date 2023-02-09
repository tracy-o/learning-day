defmodule Belfrage.Cache.Local do
  require Logger
  @behaviour Belfrage.Behaviours.CacheStrategy
  @dial Application.compile_env(:belfrage, :dial)

  alias Belfrage.Behaviours.CacheStrategy
  alias Belfrage.Envelope
  alias Belfrage.Envelope.Request
  alias Belfrage.Timer
  alias Belfrage.Metrics

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
  def fetch(%Envelope{request: %Request{request_hash: request_hash}}, caching_module \\ Cachex) do
    if @dial.state(:cache_enabled) do
      try do
        caching_module.touch(:cache, request_hash)

        :cache
        |> caching_module.get(request_hash)
        |> format_cache_result()
      catch
        :exit, cause ->
          Metrics.event([:cache, :local, :fetch_exit])
          Logger.log(:error, "", %{msg: "Attempt to fetch from the local cache failed: #{inspect(cause)}"})
          {:ok, :content_not_found}
      end
    else
      {:ok, :content_not_found}
    end
  end

  @impl CacheStrategy
  def store(
        envelope = %Belfrage.Envelope{
          private: %Belfrage.Envelope.Private{personalised_route: personalised_route},
          response: %Belfrage.Envelope.Response{
            cache_directive: %Belfrage.CacheControl{max_age: max_age},
            cache_last_updated: cache_last_updated
          }
        },
        # Options are:
        #   :cache_name - The name of the cache to be used
        #   :make_stale - Whether or not to make the cache entry stale
        opts \\ []
      ) do
    if cacheable?(max_age) && stale?(cache_last_updated, max_age) && @dial.state(:cache_enabled) do
      %{cache_name: cache, make_stale: make_stale} = Enum.into(opts, %{cache_name: :cache, make_stale: false})

      Cachex.put(
        cache,
        envelope.request.request_hash,
        %{
          envelope.response
          | personalised_route: personalised_route,
            cache_last_updated: maybe_make_stale(Timer.now_ms(), max_age, make_stale)
        },
        ttl: envelope.private.fallback_ttl
      )
    else
      {:ok, false}
    end
  end

  @impl CacheStrategy
  def metric_identifier, do: "local"

  defp cacheable?(_max_age = nil), do: false
  defp cacheable?(_max_age), do: true

  defp format_cache_result({:ok, response = %Belfrage.Envelope.Response{cache_last_updated: last_updated}})
       when not is_nil(last_updated) do
    %{max_age: max_age} = response.cache_directive

    case stale?(last_updated, max_age) do
      true -> {:ok, {:local, :stale}, response}
      false -> {:ok, {:local, :fresh}, response}
    end
  end

  defp format_cache_result({:ok, nil}) do
    {:ok, :content_not_found}
  end

  defp stale?(nil, _max_age), do: true

  defp stale?(last_updated, max_age) do
    Belfrage.Timer.stale?(last_updated, max_age)
  end

  defp maybe_make_stale(time, max_age, make_stale) do
    if make_stale do
      Timer.make_stale(time, max_age)
    else
      time
    end
  end
end
