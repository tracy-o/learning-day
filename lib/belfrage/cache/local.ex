defmodule Belfrage.Cache.Local do
  @behaviour CacheStrategy

  alias Belfrage.Behaviours.CacheStrategy

  @impl CacheStrategy
  def fetch(%Belfrage.Struct{request: %{request_hash: request_hash}}, cache \\ :cache) do
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
