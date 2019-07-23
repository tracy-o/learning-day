defmodule Belfrage.Cache.Local do
  def fetch(
        %Belfrage.Struct{
          request: %{request_hash: request_hash}
        }
      ) do
    Cachex.get(:cache, request_hash)
    |> format_cache_result()
  end

  def store(struct = %Belfrage.Struct{}) do
    case stale?(struct) do
      true ->
        Cachex.put(
          :cache,
          struct.request.request_hash,
          {struct.response, Belfrage.Timer.now_ms()},
          ttl: struct.private.fallback_ttl
        )

      false ->
        {:ok, false}
    end
  end

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

  defp stale?(struct) do
    case fetch(struct) do
      {:ok, :fresh, _fetched} -> false
      _ -> true
    end
  end
end
